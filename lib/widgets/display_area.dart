import 'package:flutter/material.dart';
import 'package:flutter_caculator_nguyennamphuong/providers/calculator_provider.dart';
import 'package:flutter_caculator_nguyennamphuong/models/calculator_mode.dart';
import 'package:provider/provider.dart';

class DisplayArea extends StatelessWidget {
  final String expression;
  final String result;
  const DisplayArea({
    super.key,
    required this.expression,
    required this.result,
  });
  @override
  Widget build(BuildContext context) {
    //Lấy theme hiện tại của ứng dụng
    final theme = Theme.of(context);

    return Container(
      //Thay đổi màu nền và bo góc
      color: Colors.transparent, // Nền trong suốt để lấy màu từ Scaffold
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          //Hàng chứa các chỉ báo và nút chuyển chế độ
          Consumer<CalculatorProvider>(
            builder: (context, calculator, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Chỉ báo chế độ góc (DEG/RAD)
                  Text(
                    calculator.isRadMode ? 'RAD' : 'DEG',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              );
            },
          ),
          //Biểu thức (dòng trên)
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              expression,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white.withOpacity(0.7),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Spacer(),
          //Kết quả
          //Sử dụng FittedBox để font chữ tự động co lại nếu số quá dài
          Align(
            alignment: Alignment.bottomRight,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                result,
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
