import 'package:flutter/material.dart';
import 'package:flutter_caculator_nguyennamphuong/models/calculator_mode.dart';
import 'package:flutter_caculator_nguyennamphuong/providers/calculator_provider.dart';
import 'package:flutter_caculator_nguyennamphuong/widgets/calculator_button.dart';
import 'package:provider/provider.dart';

class ButtonGrid extends StatelessWidget {
  const ButtonGrid({super.key});
  //Dữ liệu cho lưới Chế độ Cơ bản (danh sách phẳng)
  final List<String> _basicButtons = const [
    'C',
    'CE',
    '%',
    '÷',
    '7',
    '8',
    '9',
    '×',
    '4',
    '5',
    '6',
    '-',
    '1',
    '2',
    '3',
    '+',
    '+/-',
    '0',
    '.',
    '=',
  ];
  //Dữ liệu cho các nút chỉ có ở chế độ Khoa học (phần trên, 6 cột)
  final List<String> _scientificOnlyButtons = const [
    '(',
    ')',
    'mc',
    'm+',
    'm-',
    'mr',
    '2nd',
    'x²',
    'x³',
    'xʸ',
    'e^x',
    '10^x',
    '1/x',
    '√',
    '∛',
    'ʸ√x',
    'ln',
    'log₁₀',
    'x!',
    'sin',
    'cos',
    'tan',
    'e',
    'EE',
    'Rand',
    'sinh',
    'cosh',
    'tanh',
    'π',
    'Deg',
  ];
  @override
  Widget build(BuildContext context) {
    //Sử dụng Consumer để lắng nghe sự thay đổi của CalculatorProvider
    return Consumer<CalculatorProvider>(
      builder: (context, calculatorProvider, child) {
        // Chọn layout dựa trên chế độ hiện tại
        if (calculatorProvider.mode == CalculatorMode.basic) {
          return _buildBasicGrid(context, calculatorProvider);
        } else {
          return _buildScientificGrid(context, calculatorProvider);
        }
      },
    );
  }

  ///Hàm xây dựng lưới cho chế độ cơ bản.
  Widget _buildBasicGrid(
    BuildContext context,
    CalculatorProvider calculatorProvider,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const crossAxisCount = 4;
        const mainAxisCount = 5;
        const crossAxisSpacing = 12.0;
        const mainAxisSpacing = 12.0;

        final buttonWidth =
            (constraints.maxWidth - (crossAxisCount - 1) * crossAxisSpacing) /
            crossAxisCount;
        final buttonHeight =
            (constraints.maxHeight - (mainAxisCount - 1) * mainAxisSpacing) /
            mainAxisCount;
        final aspectRatio = buttonWidth / buttonHeight;

        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: crossAxisSpacing,
            mainAxisSpacing: mainAxisSpacing,
            childAspectRatio: aspectRatio,
          ),
          itemCount: _basicButtons.length,
          itemBuilder: (context, index) {
            final buttonText = _basicButtons[index];
            return CalculatorButton(
              text: buttonText,
              onPressed: () => calculatorProvider.buttonPressed(buttonText),
            );
          },
        );
      },
    );
  }

  ///Hàm xây dựng lưới cho chế độ khoa học bằng Column/Row.
  Widget _buildScientificGrid(
    BuildContext context,
    CalculatorProvider calculatorProvider,
  ) {
    return Column(
      children: [
        //Lưới các nút khoa học (6 cột)
        Expanded(
          flex: 5, // 5 hàng
          child: LayoutBuilder(
            builder: (context, constraints) {
              const crossAxisCount = 6;
              const mainAxisCount = 5;
              const crossAxisSpacing = 12.0;
              const mainAxisSpacing = 12.0;

              final buttonWidth =
                  (constraints.maxWidth -
                      (crossAxisCount - 1) * crossAxisSpacing) /
                  crossAxisCount;
              final buttonHeight =
                  (constraints.maxHeight -
                      (mainAxisCount - 1) * mainAxisSpacing) /
                  mainAxisCount;
              final aspectRatio = buttonWidth / buttonHeight;
              return GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: crossAxisSpacing,
                  mainAxisSpacing: mainAxisSpacing,
                  childAspectRatio: aspectRatio,
                ),
                itemCount: _scientificOnlyButtons.length,
                itemBuilder: (context, index) {
                  final buttonText = _scientificOnlyButtons[index];
                  return CalculatorButton(
                    text: buttonText,
                    onPressed: () =>
                        calculatorProvider.buttonPressed(buttonText),
                  );
                },
              );
            },
          ),
        ),
        //Thêm một khoảng trống nhỏ giữa hai lưới
        const SizedBox(height: 12.0),
        //Lưới các nút cơ bản (4 cột)
        Expanded(
          flex: 5,
          child: LayoutBuilder(
            builder: (context, constraints) {
              const crossAxisCount = 4;
              const mainAxisCount = 5;
              const crossAxisSpacing = 12.0;
              const mainAxisSpacing = 12.0;

              final buttonWidth =
                  (constraints.maxWidth -
                      (crossAxisCount - 1) * crossAxisSpacing) /
                  crossAxisCount;
              final buttonHeight =
                  (constraints.maxHeight -
                      (mainAxisCount - 1) * mainAxisSpacing) /
                  mainAxisCount;
              final aspectRatio = buttonWidth / buttonHeight;
              return GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: crossAxisSpacing,
                  mainAxisSpacing: mainAxisSpacing,
                  childAspectRatio: aspectRatio,
                ),
                itemCount: _basicButtons.length,
                itemBuilder: (context, index) => CalculatorButton(
                  text: _basicButtons[index],
                  onPressed: () =>
                      calculatorProvider.buttonPressed(_basicButtons[index]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
