import 'package:flutter/material.dart';
import 'models/tip.dart';
import 'db/tip_database.dart';

void main() {
  runApp(TipApp());
}

class TipApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cálculo de Gorjeta',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: TipHomePage(),
    );
  }
}

class TipHomePage extends StatefulWidget {
  @override
  _TipHomePageState createState() => _TipHomePageState();
}

class _TipHomePageState extends State<TipHomePage> {
  final TextEditingController _controller = TextEditingController();
  double _bill = 0.0;
  List<Tip> _history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() async {
    final tips = await TipDatabase.instance.getAllTips();
    setState(() {
      _history = tips;
    });
  }

  void _calculateTip(double percent) async {
    final tipAmount = _bill * percent;
    final newTip = Tip(
      billAmount: _bill,
      tipAmount: tipAmount,
      percentage: percent,
    );
    await TipDatabase.instance.insertTip(newTip);
    _controller.clear();
    setState(() {
      _bill = 0.0;
    });
    _loadHistory();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Gorjeta de R\$ ${tipAmount.toStringAsFixed(2)} salva.')),
    );
  }

  Widget _tipButton(double percent) {
    return ElevatedButton(
      onPressed: () => _calculateTip(percent),
      child: Text('${(percent * 100).toInt()}%'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cálculo de Gorjeta')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          TextField(
            controller: _controller,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(labelText: 'Valor da Conta (R\$)'),
            onChanged: (val) {
              setState(() {
                _bill = double.tryParse(val.replaceAll(',', '.')) ?? 0.0;
              });
            },
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _tipButton(0.10),
              _tipButton(0.15),
              _tipButton(0.20),
            ],
          ),
          SizedBox(height: 30),
          Text('Histórico', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: ListView.builder(
              itemCount: _history.length,
              itemBuilder: (context, index) {
                final tip = _history[index];
                return ListTile(
                  title: Text(
                    'Conta: R\$ ${tip.billAmount.toStringAsFixed(2)} - Gorjeta ${tip.percentage * 100}%: R\$ ${tip.tipAmount.toStringAsFixed(2)}',
                  ),
                );
              },
            ),
          )
        ]),
      ),
    );
  }
}
