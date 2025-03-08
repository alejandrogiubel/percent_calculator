import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

var themeMode = ValueNotifier(ThemeMode.system);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: themeMode,
      builder:
          (context, value, child) => MaterialApp(
            title: 'Calcular porciento',
            home: const MyHomePage(title: 'Calcular porciento'),
            themeMode: value,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
          ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _percent = 0;
  double _total = 0;
  final _controllerNumber = TextEditingController();
  final _controllerPercent = TextEditingController();
  late final CurrencyTextInputFormatter _formatterNumber;
  late final CurrencyTextInputFormatter _formatterPercent;

  @override
  void initState() {
    super.initState();
    _controllerNumber.addListener(() {
      if (_controllerNumber.text.isEmpty) {
        setState(() {
          _percent = 0;
          _total = 0;
        });
      }
    });
    _controllerPercent.addListener(() {
      if (_controllerPercent.text.isEmpty) {
        setState(() {
          _percent = 0;
          _total = 0;
        });
      }
    });
    _formatterNumber = CurrencyTextInputFormatter.simpleCurrency(
      minValue: 0,
      onChange: (p0) {
        _computePercent();
        _computeTotal();
      },
    );
    _formatterPercent = CurrencyTextInputFormatter(
      NumberFormat.decimalPattern(),
      minValue: 0,
      maxValue: 100,
      onChange: (p0) {
        _computePercent();
        _computeTotal();
      },
    );
  }

  void _computePercent() {
    setState(() {
      final number = _formatterNumber.getDouble();
      final percent = _formatterPercent.getDouble();
      _percent = number * (percent / 100);
    });
  }

  void _computeTotal() {
    setState(() {
      final number = _formatterNumber.getDouble();
      _total = number - _percent;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon:
                themeMode.value == ThemeMode.dark
                    ? const Icon(Icons.dark_mode)
                    : const Icon(Icons.light_mode),
            onPressed: () {
              themeMode.value =
                  themeMode.value == ThemeMode.dark
                      ? ThemeMode.light
                      : ThemeMode.dark;
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              spacing: 24,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Porciento',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      Text(
                        NumberFormat.decimalPattern().format(_percent),
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                    ],
                  ),
                ),
                TextField(
                  controller: _controllerNumber,
                  decoration: InputDecoration(
                    hintText: 'Ingrese número',
                    labelText: 'Ingrese número',
                    hintStyle: Theme.of(context).textTheme.bodyLarge,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        _controllerNumber.clear();
                        _clearComputations();
                      },
                      icon: Icon(Icons.clear),
                    ),
                  ),
                  style: Theme.of(context).textTheme.bodyLarge,
                  keyboardType: TextInputType.numberWithOptions(
                    decimal: true,
                  ), // Permite decimales
                  inputFormatters: [_formatterNumber],
                ),
                TextField(
                  controller: _controllerPercent,
                  decoration: InputDecoration(
                    hintText: 'Ingrese porciento',
                    labelText: 'Ingrese porciento',
                    hintStyle: Theme.of(context).textTheme.bodyLarge,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        _controllerPercent.clear();
                        _clearComputations();
                      },
                      icon: Icon(Icons.clear),
                    ),
                  ),
                  style: Theme.of(context).textTheme.bodyLarge,
                  keyboardType: TextInputType.numberWithOptions(
                    decimal: true,
                  ), // Permite decimales
                  inputFormatters: [_formatterPercent],
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Theme.of(context).colorScheme.tertiaryContainer,
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Diferencia',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      Text(
                        NumberFormat.decimalPattern().format(_total),
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _clearAll,
        tooltip: 'Limpiar',
        child: const Icon(Icons.clear),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _clearComputations() {
    setState(() {
      _percent = 0;
      _total = 0;
    });
  }

  void _clearAll() {
    setState(() {
      _controllerNumber.clear();
      _controllerPercent.clear();
      _percent = 0;
      _total = 0;
    });
  }
}
