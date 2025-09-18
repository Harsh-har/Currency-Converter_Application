import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({super.key});

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  List<String> watchlist = [];

  @override
  void initState() {
    super.initState();
    _loadWatchlist();
  }

  Future<void> _loadWatchlist() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      watchlist = prefs.getStringList('watchlist') ?? [];
    });
  }

  Future<void> _removeFromWatchlist(String pair) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      watchlist.remove(pair);
      prefs.setStringList('watchlist', watchlist);
      Fluttertoast.showToast(
          msg: '$pair removed from watchlist',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Watchlist"),
        centerTitle: true,
      ),
      body: watchlist.isEmpty
          ? const Center(
          child: Text(
            "No currencies in watchlist",
            style: TextStyle(fontSize: 18),
          ))
          : ListView.builder(
        itemCount: watchlist.length,
        itemBuilder: (context, index) {
          final pair = watchlist[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(
                pair,
                style: const TextStyle(fontSize: 18),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _removeFromWatchlist(pair),
              ),
            ),
          );
        },
      ),
    );
  }
}
//git
