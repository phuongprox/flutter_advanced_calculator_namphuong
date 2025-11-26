import 'package:flutter/material.dart';
import 'package:flutter_caculator_nguyennamphuong/models/calculator_mode.dart';
import 'package:flutter_caculator_nguyennamphuong/providers/calculator_provider.dart';
import 'package:flutter_caculator_nguyennamphuong/providers/theme_provider.dart';
import 'package:flutter_caculator_nguyennamphuong/providers/history_provider.dart';
import 'package:flutter_caculator_nguyennamphuong/screens/settings_screen.dart';
import 'package:flutter_caculator_nguyennamphuong/screens/history_screen.dart'; // Giả sử bạn có màn hình này
import 'package:flutter_caculator_nguyennamphuong/widgets/button_grid.dart';
import 'package:flutter_caculator_nguyennamphuong/widgets/display_area.dart';
import 'package:provider/provider.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final historyProvider = Provider.of<HistoryProvider>(
      context,
      listen: false,
    );
    return Consumer<CalculatorProvider>(
      builder: (context, calculatorProvider, child) {
        //Logic hiển thị dựa trên trạng thái tính toán
        final bool isCalculated = calculatorProvider.isResultCalculated;
        //Nếu đã tính toán, dòng biểu thức sẽ trống. Nếu không, hiển thị biểu thức đang nhập.
        final String expressionToShow = isCalculated
            ? ''
            : calculatorProvider.expression;
        //Nếu đã tính toán, hiển thị kết quả. Nếu không, hiển thị biểu thức đang nhập (hoặc '0' nếu trống).
        final String resultToShow = isCalculated
            ? calculatorProvider.result
            : (calculatorProvider.expression.isEmpty
                  ? '0'
                  : calculatorProvider.expression);
        return Scaffold(
          //Sử dụng AppBar để chứa các nút chức năng
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            //Sử dụng Row trong title để kiểm soát căn chỉnh tốt hơn
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //Dropdown để chọn chế độ
                DropdownButton<CalculatorMode>(
                  value: calculatorProvider.mode,
                  onChanged: (CalculatorMode? newValue) {
                    if (newValue != null) {
                      calculatorProvider.setMode(newValue);
                    }
                  },
                  items: CalculatorMode.values
                      .map<DropdownMenuItem<CalculatorMode>>((
                        CalculatorMode value,
                      ) {
                        return DropdownMenuItem<CalculatorMode>(
                          value: value,
                          child: Text(
                            value.toString().split('.').last.toUpperCase(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black, // Đổi thành màu đen
                            ),
                          ),
                        );
                      })
                      .toList(),
                  underline: Container(), //Bỏ gạch chân
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                  dropdownColor: const Color(0xFF333333), // Màu nền dropdown
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.history, color: Colors.black),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HistoryScreen(),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.menu, color: Colors.black),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingsScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: <Widget>[
                //Khu vực hiển thị kết quả
                Expanded(
                  flex: 3, // Tỷ lệ 30% không gian
                  child: DisplayArea(
                    expression: expressionToShow,
                    result: resultToShow,
                  ),
                ),
                // Lưới nút bấm
                // Expanded sẽ chiếm toàn bộ không gian dọc còn lại.
                const Expanded(
                  flex: 7,
                  child: ButtonGrid(),
                ), // Tỷ lệ 70% không gian
              ],
            ),
          ),
        );
      },
    );
  }
}
