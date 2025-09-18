
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Graph_Screen.dart';
import 'Watchlist Screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _amountController = TextEditingController();
  String? fromCurrency;
  String? toCurrency;
  double? convertedValue;

  Map<String, double> rates = {};
  List<String> currencies = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRates();
  }

  Future<void> _fetchRates() async {
    setState(() => isLoading = true);
    try {
      final url = Uri.parse('https://open.er-api.com/v6/latest/USD');
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        Map<String, double> newRates = Map<String, double>.from(
            (data['rates'] as Map).map((key, value) => MapEntry(key, (value as num).toDouble()))
        );

        setState(() {
          rates = newRates;
          currencies = rates.keys.toList()..sort();
          fromCurrency ??= 'USD';
          toCurrency ??= 'INR';
          isLoading = false;
        });
      } else {
        _showError("Failed to fetch rates: ${response.statusCode}");
      }
    } catch (e) {
      _showError("Error fetching rates: $e");
    }
  }

  void _showError(String msg) {
    setState(() => isLoading = false);
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16);
  }

  void _convertCurrency() {
    if (rates.isEmpty || fromCurrency == null || toCurrency == null) return;
    double amount = double.tryParse(_amountController.text) ?? 0;
    double fromRate = rates[fromCurrency!]!;
    double toRate = rates[toCurrency!]!;
    setState(() {
      convertedValue = amount * (toRate / fromRate);
    });
  }

  Future<void> _addToWatchlist() async {
    if (fromCurrency == null || toCurrency == null) return;
    String pair = '$fromCurrency/$toCurrency';
    final prefs = await SharedPreferences.getInstance();
    List<String> watchlist = prefs.getStringList('watchlist') ?? [];
    if (!watchlist.contains(pair)) {
      watchlist.add(pair);
      await prefs.setStringList('watchlist', watchlist);
      Fluttertoast.showToast(
          msg: '$pair added to watchlist',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white);
    } else {
      Fluttertoast.showToast(
          msg: '$pair already in watchlist',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.orange,
          textColor: Colors.white);
    }
  }

  void _goToWatchlist() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const WatchlistScreen()));
  }

  void _goToGraph() {
    if (rates.isNotEmpty) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SimpleBarChart(data: rates),
          )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Currency Converter"),
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.star), onPressed: _goToWatchlist),
          IconButton(icon: const Icon(Icons.show_chart), onPressed: _goToGraph),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Amount",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.attach_money),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: fromCurrency,
                    decoration: const InputDecoration(
                      labelText: "From",
                      border: OutlineInputBorder(),
                    ),
                    items: currencies
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (val) => setState(() => fromCurrency = val),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: toCurrency,
                    decoration: const InputDecoration(
                      labelText: "To",
                      border: OutlineInputBorder(),
                    ),
                    items: currencies
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (val) => setState(() => toCurrency = val),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _convertCurrency,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.blue[300],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text("Convert", style: TextStyle(fontSize: 18,color: Colors.black)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _addToWatchlist,
                    icon: const Icon(Icons.star_border),
                    label: const Text("Add to Watchlist"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (convertedValue != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.green)),
                child: Text(
                  "$fromCurrency → $toCurrency = ${convertedValue!.toStringAsFixed(2)}",
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
