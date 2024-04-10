import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: Calculator()));
}

class Calculator extends StatefulWidget {
  const Calculator({Key? key}) : super(key: key);

  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  // Variável para armazenar o valor exibido na calculadora
  String _display = '0';

  // Variáveis para armazenar o primeiro número, a operação selecionada e um indicador de reinício do display
  double _firstNumber = 0.0;
  String _operation = '';
  bool _shouldResetDisplay = false;

  // Função para realizar cálculos com base no botão pressionado
  void _calculate(String key) {
    setState(() {
      if (key == 'AC') {
        // Se o botão 'AC' for pressionado, redefinir a calculadora para o estado inicial
        _display = '0';
        _firstNumber = 0.0;
        _operation = '';
        _shouldResetDisplay = false;
      } else if (key == '⌫') {
        // Se o botão '⌫' for pressionado, remover o último dígito do display
        _display = _display.substring(0, _display.length - 1);
        if (_display.isEmpty) _display = '0';
      } else if (key == '+' || key == '-' || key == '×' || key == '÷') {
        // Se um operador for pressionado, armazenar o primeiro número e a operação selecionada
        if (_operation.isNotEmpty) _performOperation();
        _operation = key;
        _firstNumber = double.parse(_display.replaceAll(',', '.'));
        _display = '0';
        _shouldResetDisplay = false;
      } else if (key == '=') {
        // Se o botão '=' for pressionado, realizar o cálculo
        if (_operation.isNotEmpty) _performOperation();
      } else {
        // Se um número for pressionado, atualizar o display
        if (_shouldResetDisplay) {
          _display = '0';
          _shouldResetDisplay = false;
        }
        _display = _display == '0' && key != ',' ? key : _display + key;
      }
    });
  }

  // Função para realizar a operação matemática
  void _performOperation() {
    double secondNumber = double.parse(_display.replaceAll(',', '.'));
    double result = 0.0;
    switch (_operation) {
      case '+':
        result = _firstNumber + secondNumber;
        break;
      case '-':
        result = _firstNumber - secondNumber;
        break;
      case '×':
        result = _firstNumber * secondNumber;
        break;
      case '÷':
        if (secondNumber != 0) {
          result = _firstNumber / secondNumber;
        } else {
          // Se a divisão por zero for detectada, exibir 'Error'
          print('Erro: Divisão por Zero!');
          _display = 'Error';
          return;
        }
        break;
      default:
        return;
    }
    // Atualizar o display com o resultado da operação
    _display = result.toString().replaceAll('.', ',');
    _shouldResetDisplay = true;
    _operation = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calculadora')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Exibir o valor atual na calculadora
          Text(_display, style: const TextStyle(fontSize: 72)),
          // Adicionar uma linha divisória
          Divider(height: 1, color: Colors.grey),
          // Criar botões para os números e operadores
          for (var row in [
            ['AC', '⌫'],
            ['7', '8', '9', '÷'],
            ['4', '5', '6', '×'],
            ['1', '2', '3', '-'],
            ['0', ',', '=', '+']
          ])
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (var item in row)
                  ElevatedButton(
                    // Estilizar os botões
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      padding: EdgeInsets.all(24.0),
                    ),
                    // Ao pressionar um botão, chamar a função _calculate com o valor do botão
                    onPressed: () => _calculate(item),
                    child: Text(
                      item,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        // Definir a cor de fundo do rodapé
        color: Color(0xff033b69),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Exibir o nome do autor centralizado
            Text(
              'Fabio Leandro Lopes da Cunha',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            // Exibir o texto de direitos autorais centralizado
            Text(
              'Todos os direitos reservados ©',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
