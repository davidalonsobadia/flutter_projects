import 'package:advance_basics/question_summary/question_identifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class SummaryItem extends StatelessWidget {
  const SummaryItem({
    super.key,
    required this.data,
  });
  final Map<String, Object> data;

  @override
  Widget build(BuildContext context) {
    bool isCorrectAnswer = data['correct_answer'] == data['user_answer'];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        QuestionIdentifier(
          isCorrectAnswer: isCorrectAnswer,
          questionIndex: data['question_index'] as int,
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data['question'] as String,
                style: GoogleFonts.lato(
                  color: const Color.fromARGB(255, 199, 194, 208),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(
                height: 5,
              ),
              Text(data['correct_answer'] as String,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 249, 200, 218),
                  ),
                  textAlign: TextAlign.left),
              Text(data['user_answer'] as String,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 161, 195, 244),
                  ),
                  textAlign: TextAlign.left),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        )
      ],
    );
  }
}
