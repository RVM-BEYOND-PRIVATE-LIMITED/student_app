import 'dart:async';

import 'package:core_network/core_network.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';

import '../../core/api/models.dart';
import '../../core/api/student_api.dart';
import '../../injection.dart';
import '../../l10n/l10n.dart';
import '../../l10n/tr.dart';
import '../../theme/student_tokens.dart';
import '../../widgets/states.dart';
import 'api_list_screen.dart';

/// One question as the contract sends it: an id, a prompt and its options.
class QuizQuestion {
  const QuizQuestion({required this.id, required this.prompt, required this.options});

  final String id;
  final String prompt;
  final List<QuizOption> options;

  static QuizQuestion? fromJson(Object? value) {
    final map = asMap(value);
    final id = '${map['id'] ?? ''}';
    final prompt = '${map['prompt'] ?? ''}';
    if (id.isEmpty || prompt.isEmpty) return null;
    return QuizQuestion(
      id: id,
      prompt: prompt,
      options: [
        for (final option in asList(map['options']))
          if (asMap(option)['key'] != null)
            QuizOption(
              key: '${asMap(option)['key']}',
              text: '${asMap(option)['text'] ?? ''}',
            ),
      ],
    );
  }

  static List<QuizQuestion> listFromJson(Object? value) => [
    for (final row in asList(value))
      if (fromJson(row) != null) fromJson(row)!,
  ];
}

class QuizOption {
  const QuizOption({required this.key, required this.text});
  final String key;
  final String text;
}

/// The quiz of the day (#9 item 11). The server decides whether there is a
/// quiz, whether it is already answered and the score; this screen only sends
/// the chosen option key for each question.
class DailyQuizScreen extends StatefulWidget {
  const DailyQuizScreen({super.key, required this.quiz});

  final Map<String, dynamic> quiz;

  @override
  State<DailyQuizScreen> createState() => _DailyQuizScreenState();
}

class _DailyQuizScreenState extends State<DailyQuizScreen> {
  final Map<String, String> _answers = {};
  Map<String, dynamic>? _result;
  bool _busy = false;

  List<QuizQuestion> get _questions => QuizQuestion.listFromJson(widget.quiz['questions']);

  Future<void> _submit() async {
    if (_busy || _answers.length != _questions.length) return;
    setState(() => _busy = true);
    try {
      final result = await getIt<StudentApi>().postJson(
        '/v1/quizzes/daily/submit',
        {'answers': _answers},
      );
      if (!mounted) return;
      setState(() => _result = result);
    } catch (error) {
      if (!mounted) return;
      final failure = error is Failure ? error : const UnknownFailure();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(failureLine(failure, context.l10n))),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final available = widget.quiz['available'] == true;
    final answered = widget.quiz['answered'] == true;
    final result = _result;
    final correct = asMap(result?['answers'] ?? widget.quiz);
    return Scaffold(
      appBar: AppBar(title: Text(tr(context, 'Quiz of the day', 'आज की क्विज़'))),
      body: !available
          ? StudentEmptyState(
              icon: Icons.quiz_outlined,
              title: tr(context, 'There is no quiz today.', 'आज कोई क्विज़ नहीं है।'),
            )
          : ListView(
              padding: const EdgeInsets.all(RvmSpacing.lg),
              children: [
                if (answered || result != null)
                  ModuleCard(
                    child: Text(
                      '${tr(context, 'Score', 'स्कोर')}: '
                      '${result?['score'] ?? widget.quiz['score'] ?? 0}/'
                      '${result?['max_score'] ?? widget.quiz['max_score'] ?? 0}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  )
                else
                  Text(
                    tr(context, 'Answer every question, then send.', 'सभी सवालों के जवाब दें, फिर भेजें।'),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                const SizedBox(height: RvmSpacing.md),
                for (final question in _questions)
                  Padding(
                    padding: const EdgeInsets.only(bottom: RvmSpacing.md),
                    child: _QuestionCard(
                      question: question,
                      selected: _answers[question.id],
                      correctKey: result == null ? null : '${correct[question.id] ?? ''}',
                      onChanged: result != null
                          ? null
                          : (key) => setState(() => _answers[question.id] = key),
                    ),
                  ),
                if (result == null && !answered)
                  FilledButton(
                    onPressed: _busy || _answers.length != _questions.length ? null : _submit,
                    child: Text(tr(context, 'Send answers', 'जवाब भेजें')),
                  )
                else if (result?['late'] == true)
                  Text(
                    tr(context, 'Sent after the time was over; it was not scored.',
                        'समय खत्म होने के बाद भेजा गया; स्कोर नहीं हुआ।'),
                    style: TextStyle(color: context.palette.warning),
                  ),
              ],
            ),
    );
  }
}

/// A timed mock interview quiz (#9 item 12). The server sets the deadline and
/// keeps the time; the app sends its answers at the deadline even if the
/// student has not pressed Send.
class MockQuizScreen extends StatefulWidget {
  const MockQuizScreen({super.key, required this.role});

  final Map<String, dynamic> role;

  @override
  State<MockQuizScreen> createState() => _MockQuizScreenState();
}

class _MockQuizScreenState extends State<MockQuizScreen> {
  final Map<String, String> _answers = {};
  Map<String, dynamic>? _started;
  Map<String, dynamic>? _result;
  Timer? _clock;
  Duration _left = Duration.zero;
  bool _busy = false;
  bool _submitted = false;

  @override
  void initState() {
    super.initState();
    unawaited(_start());
  }

  @override
  void dispose() {
    _clock?.cancel();
    super.dispose();
  }

  Future<void> _start() async {
    setState(() => _busy = true);
    try {
      final started = await getIt<StudentApi>().postJson(
        '/v1/quizzes/mock/attempts',
        {'role_id': widget.role['id']},
      );
      if (!mounted) return;
      setState(() {
        _started = started;
        _left = _deadlineLeft(started['deadline_at']);
      });
      _clock?.cancel();
      _clock = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!mounted || _submitted) return;
        final left = _deadlineLeft(_started?['deadline_at']);
        setState(() => _left = left);
        if (left == Duration.zero) unawaited(_submit(automatic: true));
      });
    } catch (error) {
      if (!mounted) return;
      final failure = error is Failure ? error : const UnknownFailure();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(failureLine(failure, context.l10n))),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Duration _deadlineLeft(Object? raw) {
    final deadline = DateTime.tryParse('$raw');
    if (deadline == null) return Duration.zero;
    final left = deadline.difference(DateTime.now().toUtc());
    return left.isNegative ? Duration.zero : left;
  }

  Future<void> _submit({bool automatic = false}) async {
    final started = _started;
    if (_busy || _submitted || started == null) return;
    _submitted = true;
    _clock?.cancel();
    setState(() => _busy = true);
    try {
      final result = await getIt<StudentApi>().postJson(
        '/v1/quizzes/attempts/${started['attempt_id']}/submit',
        {'answers': _answers},
      );
      if (!mounted) return;
      setState(() => _result = result);
    } catch (error) {
      if (!mounted) return;
      _submitted = false;
      final failure = error is Failure ? error : const UnknownFailure();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(failureLine(failure, context.l10n))),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final started = _started;
    final questions = QuizQuestion.listFromJson(started?['questions']);
    final result = _result;
    final correct = asMap(result?['answers']);
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.role['name'] ?? tr(context, 'Mock interview', 'मॉक इंटरव्यू')}'),
      ),
      body: started == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(RvmSpacing.lg),
              children: [
                if (result == null)
                  ModuleCard(
                    child: Row(
                      children: [
                        const Icon(Icons.timer_outlined),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${tr(context, 'Time left', 'बचा समय')}: ${_clockText(_left)}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  ModuleCard(
                    child: Text(
                      '${tr(context, 'Score', 'स्कोर')}: ${result['score'] ?? 0}/${result['max_score'] ?? 0}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                const SizedBox(height: RvmSpacing.md),
                for (final question in questions)
                  Padding(
                    padding: const EdgeInsets.only(bottom: RvmSpacing.md),
                    child: _QuestionCard(
                      question: question,
                      selected: _answers[question.id],
                      correctKey: result == null ? null : '${correct[question.id] ?? ''}',
                      onChanged: result != null
                          ? null
                          : (key) => setState(() => _answers[question.id] = key),
                    ),
                  ),
                if (result == null)
                  FilledButton(
                    onPressed: _busy ? null : () => _submit(),
                    child: Text(tr(context, 'Send answers', 'जवाब भेजें')),
                  )
                else if (result['late'] == true)
                  Text(
                    tr(context, 'Sent after the time was over; it was not scored.',
                        'समय खत्म होने के बाद भेजा गया; स्कोर नहीं हुआ।'),
                    style: TextStyle(color: context.palette.warning),
                  ),
              ],
            ),
    );
  }

  String _clockText(Duration value) {
    final minutes = value.inMinutes.toString().padLeft(2, '0');
    final seconds = (value.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({
    required this.question,
    required this.selected,
    required this.correctKey,
    required this.onChanged,
  });

  final QuizQuestion question;
  final String? selected;
  final String? correctKey;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return ModuleCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(question.prompt, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: RvmSpacing.sm),
          RadioGroup<String>(
            groupValue: selected,
            onChanged: (value) {
              if (value != null) onChanged?.call(value);
            },
            child: Column(
              children: [
                for (final option in question.options)
                  RadioListTile<String>(
                    value: option.key,
                    enabled: onChanged != null,
                    title: Text(option.text),
                    secondary: correctKey == null
                        ? null
                        : correctKey == option.key
                        ? const Icon(Icons.check_circle_rounded)
                        : selected == option.key
                        ? const Icon(Icons.cancel_rounded)
                        : null,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
