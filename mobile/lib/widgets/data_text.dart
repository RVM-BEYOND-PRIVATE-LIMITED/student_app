import 'package:flutter/material.dart';

import '../theme/student_theme.dart';
import '../theme/student_tokens.dart';

/// A technical value (a request id, a version, an address, an issue number)
/// in Geist Mono. It is data, not wording, so it is shown as it is in every
/// language, and the student can select it to copy it.
class DataText extends StatelessWidget {
  const DataText(
    this.value, {
    super.key,
    this.size = 13,
    this.color = StudentColors.fg1,
    this.textAlign,
  });

  final String value;
  final double size;
  final Color color;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return SelectableText(
      value,
      textAlign: textAlign,
      style: StudentType.data(size: size, color: color),
    );
  }
}
