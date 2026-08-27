import 'dart:async';
import 'dart:io';
import 'package:android_remote_pro/android_remote_pro.dart';
import 'package:android_remote_pro/device.dart';
import 'package:android_remote_pro/key_codes.dart';
import 'package:flutter/material.dart';

void main() => runApp(const SmartRemoteApp());

class SmartRemoteApp extends StatefulWidget {
  const SmartRemoteApp({super.key});
  @override State<SmartRemoteApp> createState() => _SmartRemoteAppState();
}

class _SmartRemoteAppState extends State<SmartRemoteApp> {
  AndroidRemotePro? remote;
  StreamSubscription? scanSub;
  final Map<String, Device> devices = {};
  Device? connected;
  String status = 'Ready';
  bool scanning = false;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      remote = AndroidRemotePro();
      scanSub = remote!.scanStream().listen((raw) {
        try {
          final map = raw as Map;
          if (map['event'] == 'found') {
            final d = Device.fromJsonString(map['device'] as String);
            setState(() => devices[d.name] = d);
          } else if (map['event'] == 'removed') {
            setState(() => devices.remove(map['name']));
          }
        } catch (_) {}
      }, onError: (e) => setState(() => status = 'Scan error: $e'));
    }
  }

  Future<void> scan() async {
    if (!Platform.isAndroid || remote == null) {
      setState(() => status = 'Android only'); return;
    }
    setState(() { scanning = true; status = 'Searching for TVs…'; devices.clear(); });
    try { await remote!.startScan(); } catch (e) { setState(() => status = 'Unable to scan: $e'); }
  }

  Future<void> connect(Device d) async {
    setState(() => status = 'Connecting to ${d.name}…');
    try {
      await remote!.connect(d.host, port: d.port);
      setState(() { connected = d; status = 'Connected'; scanning = false; });
    } catch (e) {
      setState(() => status = 'Connection failed: $e');
    }
  }

  Future<void> key(int code) async {
    if (connected == null) return;
    try { await remote!.sendKey(code); }
    catch (e) { setState(() => status = 'Command failed: $e'); }
  }

  @override
  void dispose() { scanSub?.cancel(); remote?.stopScan(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.deepPurple),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: ThemeMode.system,
      home: Scaffold(
        appBar: AppBar(title: const Text('Smart Remote'), actions: [
          IconButton(onPressed: scan, icon: const Icon(Icons.refresh), tooltip: 'Find TV')
        ]),
        body: connected == null ? _discovery() : _remote(),
      ),
    );
  }

  Widget _discovery() => Padding(
    padding: const EdgeInsets.all(20),
    child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      const Icon(Icons.live_tv, size: 72),
      const SizedBox(height: 12),
      Text('Connect your TV', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineSmall),
      const SizedBox(height: 6),
      Text('Phone and TV must be on the same Wi‑Fi network.', textAlign: TextAlign.center),
      const SizedBox(height: 18),
      FilledButton.icon(onPressed: scan, icon: Icon(scanning ? Icons.sync : Icons.search), label: Text(scanning ? 'Searching…' : 'Find TV')),
      const SizedBox(height: 12),
      Text(status, textAlign: TextAlign.center),
      const SizedBox(height: 12),
      Expanded(child: devices.isEmpty ? const Center(child: Text('No TV found yet')) : ListView(children: devices.values.map((d) => Card(child: ListTile(leading: const Icon(Icons.tv), title: Text(d.name), subtitle: Text('${d.host}:${d.port}'), trailing: FilledButton(onPressed: () => connect(d), child: const Text('Connect'))))).toList())),
    ]),
  );

  Widget _remote() => SingleChildScrollView(
    padding: const EdgeInsets.all(18),
    child: Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.circle, size: 10, color: Colors.green), const SizedBox(width: 8), Text(connected!.name, style: Theme.of(context).textTheme.titleLarge)]),
      const SizedBox(height: 8), Text(status),
      const SizedBox(height: 22),
      _circle('⏻', () => key(KeyCodes.power), size: 64),
      const SizedBox(height: 18),
      _circle('▲', () => key(KeyCodes.dpadUp)),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [_circle('◀', () => key(KeyCodes.dpadLeft)), _circle('OK', () => key(KeyCodes.dpadCenter)), _circle('▶', () => key(KeyCodes.dpadRight))]),
      _circle('▼', () => key(KeyCodes.dpadDown)),
      const SizedBox(height: 16),
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [_pill('HOME', Icons.home, KeyCodes.home), _pill('BACK', Icons.arrow_back, KeyCodes.back)]),
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [_pill('VOL −', Icons.volume_down, KeyCodes.volumeDown), _pill('MUTE', Icons.volume_off, KeyCodes.mute), _pill('VOL +', Icons.volume_up, KeyCodes.volumeUp)]),
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [_pill('PREV', Icons.skip_previous, KeyCodes.mediaPrevious), _pill('PLAY', Icons.play_arrow, KeyCodes.playPause), _pill('NEXT', Icons.skip_next, KeyCodes.mediaNext)]),
      const SizedBox(height: 18),
      OutlinedButton.icon(onPressed: () => setState(() => connected = null), icon: const Icon(Icons.link_off), label: const Text('Disconnect')),
    ]),
  );

  Widget _circle(String label, VoidCallback onTap, {double size = 58}) => Padding(padding: const EdgeInsets.all(4), child: SizedBox(width: size, height: size, child: FilledButton(onPressed: onTap, style: FilledButton.styleFrom(shape: const CircleBorder(), padding: EdgeInsets.zero), child: Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)))));

  Widget _pill(String label, IconData icon, int code) => Padding(padding: const EdgeInsets.all(4), child: FilledButton.icon(onPressed: () => key(code), icon: Icon(icon), label: Text(label)));
}
