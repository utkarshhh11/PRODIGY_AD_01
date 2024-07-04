import 'package:calculator_prodigy/button_values.dart';
import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String number1 = "";
  String operand = "";
  String number2 = "";
  @override
  Widget build(BuildContext context) {
    ///final screensize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  padding: EdgeInsets.all(17),
                  alignment: Alignment.bottomRight,
                  child: Text(
                    "$number1$operand$number2".isEmpty
                        ? "0"
                        : "$number1$operand$number2",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 48),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ),
            Wrap(
              children: Btn.buttonValues
                  .map(
                    (values) => SizedBox(
                      width: values == Btn.n0 ? 400 / 2 : (400 / 4),
                      height: 500 / 5,
                      child: buildbutton(values),
                    ),
                  )
                  .toList(),
            )
          ],
        ),
      ),
    );
  }

  Widget buildbutton(values) {
    return Padding(
      padding: EdgeInsets.all(4),
      child: Material(
        color: getcolor(values),
        clipBehavior: Clip.hardEdge,
        shape: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white24),
          borderRadius: BorderRadius.circular(100),
        ),
        child: InkWell(
          onTap: () => btntap(values),
          child: Center(
              child: Text(
            values,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          )),
        ),
      ),
    );
  }
  void btntap( String values) {
    if(values==Btn.del){
      del();
      return;
    }
    if(values==Btn.clr){
      clr();
      return;
    }
    if (values == Btn.per) {
      convertToPercentage();
      return;
    }
    if (values == Btn.calculate) {
      calculate();
      return;
    }
    appendnum(values);
  }

  void calculate() {
    if (number1.isEmpty) return;
    if (operand.isEmpty) return;
    if (number2.isEmpty) return;

    final double num1 = double.parse(number1);
    final double num2 = double.parse(number2);

    var result = 0.0;
    switch (operand) {
      case Btn.add:
        result = num1 + num2;
        break;
      case Btn.subtract:
        result = num1 - num2;
        break;
      case Btn.multiply:
        result = num1 * num2;
        break;
      case Btn.divide:
        result = num1 / num2;
        break;
      default:
    }

    setState(() {
      number1 = result.toStringAsPrecision(5);

      if (number1.endsWith(".0")) {
        number1 = number1.substring(0, number1.length - 2);
      }

      operand = "";
      number2 = "";
    });
  }

  void convertToPercentage() {
    // ex: 434+324
    if (number1.isNotEmpty && operand.isNotEmpty && number2.isNotEmpty) {
      calculate();
    }

    if (operand.isNotEmpty) {
      return;
    }

    final number = double.parse(number1);
    setState(() {
      number1 = "${(number / 100)}";
      operand = "";
      number2 = "";
    });
  }

  void clr(){
    setState(() {
      number1="";
      operand="";
      number2="";
    });
  }

  void del(){
    if(number2.isNotEmpty){
      number2=number2.substring(0,number2.length-1);
    }
    else if(operand.isNotEmpty){
      operand="";
    }
    else if (number1.isNotEmpty){
      number1=number1.substring(0,number1.length-1);
    }
    setState(() {});

  }
  appendnum(String values){

    if(values!=Btn.dot && int.tryParse(values)==null){
      if(operand.isNotEmpty && number2.isNotEmpty){
        calculate();

      }
      operand = values;

    }else if (number1.isEmpty||operand.isEmpty){
      if(values == Btn.dot && number1.contains(Btn.dot))return;
      if(values == Btn.dot ||(number1.isEmpty&& number1==Btn.n0)){
        values = "0.";
      }
      number1+=values;
    }
    else if (number2.isEmpty||operand.isNotEmpty){
      if(values == Btn.dot && number2.contains(Btn.dot))return;
      if(values == Btn.dot ||(number2.isEmpty&& number2==Btn.n0)){
        values = "0.";
      }
      number2+=values;
    }

    setState(() {});

  }

   Color getcolor(values) {
    return [Btn.del, Btn.clr].contains(values)
        ? Colors.blueGrey
        : [
            Btn.per,
            Btn.multiply,
            Btn.add,
            Btn.divide,
            Btn.subtract,
            Btn.calculate
          ].contains(values)
            ? Colors.orange
            : Colors.black87;
  }
}
