import 'package:flutter/material.dart';

class CalculatorButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;

  const CalculatorButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  State<CalculatorButton> createState() => _CalculatorButtonState();
}

class _CalculatorButtonState extends State<CalculatorButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.85,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    //Xác định màu sắc và màu chữ dựa trên loại nút
    Color buttonColor;
    Color textColor = Colors.white;
    //Cập nhật các bộ nút theo yêu cầu mới
    const lightGrayButtons = {'C', 'CE', 'AC', '±', '+/-', '%'};
    const operatorButtons = {'÷', '×', '-', '+', '='};
    if (lightGrayButtons.contains(widget.text)) {
      //Nút AC/±/%: Màu Xám Sáng
      buttonColor = const Color(0xFFA6A6A6);
      textColor = Colors.black; // Chữ màu đen
    } else if (operatorButtons.contains(widget.text)) {
      buttonColor = const Color(0xFFFF9500);
      textColor = Colors.white;
    } else {
      buttonColor = const Color(0xFF333333);
      textColor = Colors.white;
    }
    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: (_) {
          _controller.forward();
        },
        onTapUp: (_) {
          _controller.reverse();
          widget.onPressed();
        },
        onTapCancel: () {
          _controller.reverse();
        },
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: ElevatedButton(
            onPressed: widget.onPressed,
            style:
                ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  foregroundColor: textColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0), // Bo góc 16px
                  ),
                  padding: const EdgeInsets.all(0), // Để Text tự căn giữa
                ).copyWith(
                  // Đảm bảo nút lấp đầy không gian
                  fixedSize: MaterialStateProperty.all(
                    const Size.fromHeight(double.infinity),
                  ),
                ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                widget.text,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                ), // Roboto Regular 20px
              ),
            ),
          ),
        ),
      ),
    );
  }
}
