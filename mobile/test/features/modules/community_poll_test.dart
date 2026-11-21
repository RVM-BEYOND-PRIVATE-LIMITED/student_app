import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rvm_student/core/api/student_api.dart';
import 'package:rvm_student/features/modules/other_modules_screens.dart';
import 'package:rvm_student/injection.dart';

import '../../support/screen.dart';

class _FakeApi extends StudentApi {
  _FakeApi() : super(Dio());

  final calls = <(String, Map<String, dynamic>)>[];

  @override
  Future<Map<String, dynamic>> getJson(String path) async => switch (path) {
    '/v1/community/groups' => {
      'groups': [
        {'id': 'g1', 'name': 'AutoCAD'},
      ],
    },
    '/v1/community/groups/g1/posts' => {
      'posts': [
        {
          'id': 'p1',
          'author': 'Asha · AutoCAD · Faridabad',
          'body': 'Which day suits everyone?',
          'comment_count': 0,
          'reaction_count': 0,
          'reacted': false,
          'mine': false,
          'hidden': false,
          'poll': {
            'vote_count': 3,
            'my_vote': null,
            'options': [
              {'id': 'o1', 'label': 'Saturday', 'vote_count': 2},
              {'id': 'o2', 'label': 'Sunday', 'vote_count': 1},
            ],
          },
        },
      ],
      'next': null,
    },
    _ => <String, dynamic>{},
  };

  @override
  Future<Map<String, dynamic>> postJson(String path, [Object? body]) async {
    calls.add((path, body is Map<String, dynamic> ? body : const {}));
    return <String, dynamic>{};
  }
}

void main() {
  testWidgets('a poll shows its options and sends one vote', (tester) async {
    await getIt.reset();
    addTearDown(getIt.reset);
    final api = _FakeApi();
    getIt.registerSingleton<StudentApi>(api);
    await tester.pumpWidget(localized(const CommunityScreen()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('AutoCAD'));
    await tester.pumpAndSettle();
    expect(find.text('Saturday'), findsOneWidget);
    expect(find.text('Sunday'), findsOneWidget);

    await tester.tap(find.text('Sunday'));
    await tester.pumpAndSettle();
    final vote = api.calls.where(
      (call) => call.$1 == '/v1/community/posts/p1/vote',
    );
    expect(vote, hasLength(1));
    expect(vote.single.$2['option_id'], 'o2');
  });
}
