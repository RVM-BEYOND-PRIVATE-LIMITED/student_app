import 'dart:convert';
import 'dart:io';

import 'package:core_network/core_network.dart';
import 'package:core_ui/core_ui.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/api/models.dart';
import '../../core/api/student_api.dart';
import '../../core/security/secure_screen.dart';
import '../../injection.dart';
import '../../l10n/l10n.dart';
import '../../l10n/tr.dart';
import '../../theme/student_tokens.dart';
import '../../widgets/states.dart';
import '../modules/api_list_screen.dart';

/// Joining (#3): the courses the app sells, the undertaking, the ID, the
/// payment and the batch. The server decides every amount and every step; the
/// app sends only what the contract names.
class JoinScreen extends StatefulWidget {
  const JoinScreen({super.key});
  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  late Future<(List<JoiningCourse>, Undertaking, Registration?, List<Branch>, List<BatchOption>)> _future = _load();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _dob = TextEditingController();
  final _current = TextEditingController();
  final _permanent = TextEditingController();
  final _father = TextEditingController();
  final _fatherPhone = TextEditingController();
  final Set<String> _courses = {};
  int? _branchId;
  Registration? _registration;
  bool _busy = false;
  bool _termsLoaded = false;
  final Set<String> _terms = {};
  String _idType = 'aadhaar';
  final _idLast4 = TextEditingController();
  final _referral = TextEditingController();
  int? _discountPaise;

  Future<(List<JoiningCourse>, Undertaking, Registration?, List<Branch>, List<BatchOption>)> _load() async {
    final api = getIt<StudentApi>();
    final results = await Future.wait([
      api.getJson('/v1/courses'),
      api.getJson('/v1/undertaking/current'),
      api.getJson('/v1/me/registrations').catchError((_) => <String, dynamic>{}),
      api.getJson('/v1/branches'),
      api.getJson('/v1/me/batches').catchError((_) => <String, dynamic>{}),
    ]);
    final courses = [
      for (final row in (results[0]['courses'] as List<dynamic>? ?? const []))
        JoiningCourse.fromJson(asMap(row)),
    ];
    final undertaking = Undertaking.fromJson(results[1]);
    final registration = results[2].isEmpty ? null : Registration.fromJson(results[2]);
    final branches = [
      for (final row in (results[3]['branches'] as List<dynamic>? ?? const []))
        Branch.fromJson(asMap(row)),
    ];
    final batches = [
      for (final row in (results[4]['batches'] as List<dynamic>? ?? const []))
        BatchOption.fromJson(asMap(row)),
    ];
    _applyRegistration(registration);
    return (courses, undertaking, registration, branches, batches);
  }

  void _applyRegistration(Registration? registration) {
    _registration = registration;
    if (registration == null) return;
    _name.text = registration.studentName ?? '';
    _email.text = registration.email ?? '';
    _dob.text = registration.dateOfBirth ?? '';
    _current.text = registration.currentAddress ?? '';
    _permanent.text = registration.permanentAddress ?? '';
    _father.text = registration.fatherName ?? '';
    _fatherPhone.text = registration.fatherPhone ?? '';
    _branchId = registration.branchId;
    _courses
      ..clear()
      ..addAll(registration.courses.map((c) => c.id));
    _idType = registration.idType ?? 'aadhaar';
    _idLast4.text = registration.idDocumentLast4 ?? '';
    _terms
      ..clear()
      ..addAll(registration.termsAccepted);
  }

  Future<void> _applyReferral() async {
    final code = _referral.text.trim();
    if (code.isEmpty) return;
    try {
      final result = await getIt<StudentApi>().postJson(
        '/v1/me/referral-code',
        {'code': code},
      );
      if (!mounted) return;
      setState(() => _discountPaise = (result['discount_paise'] as num?)?.toInt());
      _toast(
        result['applied'] == true
            ? tr(context, 'Referral code applied.', 'रेफ़रल कोड लागू हुआ।')
            : tr(context, 'This code could not be applied.', 'यह कोड लागू नहीं हो सका।'),
      );
    } catch (error) {
      _error(error);
    }
  }

  Future<void> _save() async {
    if (_busy) return;
    setState(() => _busy = true);
    final fields = RegistrationFields(
      branchId: _branchId,
      studentName: _name.text.trim(),
      email: _email.text.trim(),
      dateOfBirth: _dob.text.trim(),
      currentAddress: _current.text.trim(),
      permanentAddress: _permanent.text.trim(),
      fatherName: _father.text.trim(),
      fatherPhone: _fatherPhone.text.trim(),
      idType: _idType,
      courseIds: _courses.toList(),
    );
    try {
      final api = getIt<StudentApi>();
      final json = _registration == null
          ? await api.postJson('/v1/me/registrations', fields.toJson())
          : await api.putJson('/v1/me/registrations/${_registration!.id}', fields.toJson());
      if (!mounted) return;
      setState(() => _applyRegistration(Registration.fromJson(json)));
      _toast(tr(context, 'Saved.', 'सहेज लिया।'));
    } catch (error) {
      _error(error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _video(Undertaking undertaking, {required bool complete}) async {
    final registration = _registration;
    if (registration == null) return;
    try {
      final api = getIt<StudentApi>();
      final path = complete ? 'video-complete' : 'video-start';
      final json = await api.postJson('/v1/me/registrations/${registration.id}/$path', {});
      setState(() => _applyRegistration(Registration.fromJson(json)));
    } catch (error) {
      _error(error);
    }
  }

  Future<void> _acceptTerms() async {
    final registration = _registration;
    if (registration == null) return;
    try {
      final json = await getIt<StudentApi>().putJson(
        '/v1/me/registrations/${registration.id}/terms',
        {'accepted': _terms.toList()},
      );
      setState(() {
        _applyRegistration(Registration.fromJson(json));
        _termsLoaded = true;
      });
    } catch (error) {
      _error(error);
    }
  }

  Future<void> _uploadId() async {
    final registration = _registration;
    if (registration == null) return;
    final picked = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );
    final path = picked?.files.single.path;
    if (path == null) return;
    try {
      final json = await getIt<StudentApi>().uploadIdDocument(
        registrationId: registration.id,
        filePath: path,
        idType: _idType,
        idLast4: _idLast4.text.trim(),
      );
      setState(() => _applyRegistration(Registration.fromJson(json)));
    } catch (error) {
      _error(error);
    }
  }

  Future<void> _submit() async {
    final registration = _registration;
    if (registration == null) return;
    try {
      final json = await getIt<StudentApi>().postJson('/v1/me/registrations/${registration.id}/submit', {});
      setState(() => _applyRegistration(Registration.fromJson(json)));
    } catch (error) {
      _error(error);
    }
  }

  /// The signed undertaking as the server keeps it (contract 0.26.0, #256):
  /// a PDF in base64, saved to a temporary file and handed to the share sheet,
  /// like a receipt.
  Future<void> _shareUndertaking() async {
    final registration = _registration;
    if (registration == null) return;
    final subject = tr(context, 'RVM undertaking', 'RVM अंडरटेकिंग');
    try {
      final json = await getIt<StudentApi>().getJson(
        '/v1/me/registrations/${registration.id}/undertaking',
      );
      final base64 = '${json['pdf_base64'] ?? ''}';
      if (base64.isEmpty) return;
      final dir = await getTemporaryDirectory();
      final name = '${json['filename'] ?? 'undertaking.pdf'}';
      final file = File('${dir.path}/$name');
      await file.writeAsBytes(base64Decode(base64), flush: true);
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path, mimeType: 'application/pdf')],
          subject: subject,
        ),
      );
    } catch (error) {
      _error(error);
    }
  }

  Future<void> _pay() async {
    final registration = _registration;
    if (registration == null) return;
    try {
      final order = await getIt<StudentApi>().postJson('/v1/me/payment-orders', {
        'purpose': 'joining',
        'amount_paise': registration.totalPaise,
        'accept_non_refundable': true,
        'text_version': 1,
      });
      if (!mounted) return;
      _toast(
        order['mode'] == 'dry_run'
            ? tr(context, 'Payment is not live yet. Your centre will confirm it.', 'भुगतान अभी लाइव नहीं है। आपका सेंटर पुष्टि करेगा।')
            : tr(context, 'Payment started.', 'भुगतान शुरू हुआ।'),
      );
    } catch (error) {
      _error(error);
    }
  }

  Future<void> _chooseBatch(BatchOption batch) async {
    try {
      final json = await getIt<StudentApi>().postJson('/v1/me/batch-choices', {
        'batch_id': batch.batchId,
        'course_id': batch.courseId,
      });
      if (!mounted) return;
      if (!mounted) return;
      final state = json['state'];
      _toast(
        state == 'recorded_dry_run'
            ? tr(context, 'Choice recorded; the centre will confirm it.', 'चुनाव दर्ज हुआ; सेंटर पुष्टि करेगा।')
            : tr(context, 'Seat taken.', 'सीट ले ली।'),
      );
    } catch (error) {
      _error(error);
    }
  }

  void _toast(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  void _error(Object error) {
    if (!mounted) return;
    final failure = error is Failure ? error : const UnknownFailure();
    _toast(failureLine(failure, context.l10n));
  }

  @override
  Widget build(BuildContext context) {
    return SecureScreen(
      child: Scaffold(
      appBar: AppBar(title: Text(tr(context, 'Join RVM', 'RVM से जुड़ें'))),
      body: FutureBuilder<(List<JoiningCourse>, Undertaking, Registration?, List<Branch>, List<BatchOption>)>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SkeletonList(count: 4);
          }
          if (snapshot.hasError) {
            final error = snapshot.error;
            return StudentErrorState(
              failure: error is Failure ? error : const UnknownFailure(),
              onRetry: () => setState(() => _future = _load()),
            );
          }
          final (courses, undertaking, _, branches, batches) = snapshot.data!;
          final registration = _registration;
          return ListView(
            padding: const EdgeInsets.all(RvmSpacing.lg),
            children: [
              Text(tr(context, 'Referral code', 'रेफ़रल कोड'),
                  style: Theme.of(context).textTheme.titleMedium),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _referral,
                      textCapitalization: TextCapitalization.characters,
                      decoration: InputDecoration(
                        hintText: tr(context, 'A friend\'s code', 'किसी मित्र का कोड'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: _applyReferral,
                    child: Text(tr(context, 'Apply', 'लागू करें')),
                  ),
                ],
              ),
              if (_discountPaise != null)
                Text(
                  '${tr(context, 'Discount', 'छूट')}: ${money(_discountPaise!)}',
                  style: TextStyle(color: context.palette.success),
                ),
              const SizedBox(height: RvmSpacing.md),
              if (registration == null) ...[
                Text(tr(context, 'Choose a course', 'कोर्स चुनें'),
                    style: Theme.of(context).textTheme.titleMedium),
                for (final course in courses)
                  CheckboxListTile(
                    value: _courses.contains(course.id),
                    title: Text(course.name),
                    subtitle: Text(money(course.pricePaise)),
                    onChanged: (on) => setState(() {
                      if (on == true) {
                        _courses.add(course.id);
                      } else {
                        _courses.remove(course.id);
                      }
                    }),
                  ),
                DropdownButtonFormField<int>(
                  initialValue: _branchId,
                  decoration: InputDecoration(labelText: tr(context, 'Centre', 'सेंटर')),
                  items: [
                    for (final branch in branches)
                      DropdownMenuItem(value: branch.id, child: Text(branch.name)),
                  ],
                  onChanged: (value) => setState(() => _branchId = value),
                ),
                const SizedBox(height: RvmSpacing.sm),
                _field(_name, tr(context, 'Full name', 'पूरा नाम')),
                _field(_email, tr(context, 'Email', 'ईमेल')),
                _field(_dob, tr(context, 'Date of birth (YYYY-MM-DD)', 'जन्म तिथि')),
                _field(_current, tr(context, 'Current address', 'वर्तमान पता')),
                _field(_permanent, tr(context, 'Permanent address', 'स्थायी पता')),
                _field(_father, tr(context, "Father's name", 'पिता का नाम')),
                _field(_fatherPhone, tr(context, "Father's phone", 'पिता का फोन')),
                FilledButton(
                  onPressed: _busy || _courses.isEmpty ? null : _save,
                  child: Text(tr(context, 'Save and continue', 'सहेजें और आगे बढ़ें')),
                ),
              ] else ...[
                Text(tr(context, 'Undertaking', 'वचन'), style: Theme.of(context).textTheme.titleMedium),
                TextButton.icon(
                  onPressed: () => launchUrl(undertaking.videoUri),
                  icon: const Icon(Icons.play_circle_outline_rounded),
                  label: Text(tr(context, 'Watch the video', 'वीडियो देखें')),
                ),
                Row(
                  children: [
                    OutlinedButton(
                      onPressed: () => _video(undertaking, complete: false),
                      child: Text(tr(context, 'Video started', 'वीडियो शुरू')),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: registration.videoStartedAt == null
                          ? null
                          : () => _video(undertaking, complete: true),
                      child: Text(tr(context, 'Video finished', 'वीडियो पूरा')),
                    ),
                  ],
                ),
                for (final term in undertaking.terms)
                  CheckboxListTile(
                    value: _terms.contains(term.key),
                    title: Text(term.text),
                    onChanged: (on) => setState(() {
                      if (on == true) {
                        _terms.add(term.key);
                      } else {
                        _terms.remove(term.key);
                      }
                    }),
                  ),
                FilledButton(
                  onPressed: _termsLoaded ? null : _acceptTerms,
                  child: Text(tr(context, 'Accept terms', 'शर्तें स्वीकारें')),
                ),
                const SizedBox(height: RvmSpacing.md),
                Text(tr(context, 'ID document', 'पहचान पत्र'), style: Theme.of(context).textTheme.titleMedium),
                DropdownButtonFormField<String>(
                  initialValue: _idType,
                  decoration: InputDecoration(labelText: tr(context, 'ID type', 'पहचान का प्रकार')),
                  items: const [
                    DropdownMenuItem(value: 'aadhaar', child: Text('Aadhaar')),
                    DropdownMenuItem(value: 'pan', child: Text('PAN')),
                    DropdownMenuItem(value: 'voter_id', child: Text('Voter ID')),
                    DropdownMenuItem(value: 'driving_licence', child: Text('Driving licence')),
                    DropdownMenuItem(value: 'passport', child: Text('Passport')),
                  ],
                  onChanged: (value) => setState(() => _idType = value ?? 'aadhaar'),
                ),
                _field(_idLast4, tr(context, 'Last 4 characters of the ID', 'पहचान के अंतिम 4 अक्षर')),
                OutlinedButton.icon(
                  onPressed: _uploadId,
                  icon: const Icon(Icons.upload_file_rounded),
                  label: Text(tr(context, 'Upload ID', 'पहचान अपलोड करें')),
                ),
                const SizedBox(height: RvmSpacing.md),
                if (registration.missing.isNotEmpty)
                  Text(
                    '${tr(context, 'Still needed', 'अभी बाकी')}: ${registration.missing.join(', ')}',
                    style: TextStyle(color: context.palette.warning),
                  ),
                FilledButton(
                  onPressed: registration.submitted ? null : _submit,
                  child: Text(tr(context, 'Submit', 'जमा करें')),
                ),
                if (registration.submitted) ...[
                  const SizedBox(height: RvmSpacing.sm),
                  OutlinedButton.icon(
                    onPressed: _shareUndertaking,
                    icon: const Icon(Icons.picture_as_pdf_rounded),
                    label: Text(tr(context, 'My signed undertaking', 'मेरी हस्ताक्षरित अंडरटेकिंग')),
                  ),
                  const SizedBox(height: RvmSpacing.md),
                  Text('${tr(context, 'Total', 'कुल')}: ${money(registration.totalPaise)}',
                      style: Theme.of(context).textTheme.titleMedium),
                  FilledButton(
                    onPressed: _pay,
                    child: Text(tr(context, 'Pay', 'भुगतान')),
                  ),
                  if (batches.isNotEmpty) ...[
                    const SizedBox(height: RvmSpacing.md),
                    Text(tr(context, 'Choose a batch', 'बैच चुनें'),
                        style: Theme.of(context).textTheme.titleMedium),
                    for (final batch in batches)
                      ModuleCard(
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(batch.courseName),
                                  Text(
                                    '${dateText(batch.startDate)} · ${batch.startTime ?? ''}–${batch.endTime ?? ''}',
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () => _chooseBatch(batch),
                              child: Text(tr(context, 'Choose', 'चुनें')),
                            ),
                          ],
                        ),
                      ),
                  ],
                ],
              ],
            ],
          );
        },
      ),
    ),
    );
  }

  Widget _field(TextEditingController controller, String label) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
    ),
  );
}
