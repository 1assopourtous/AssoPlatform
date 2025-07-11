import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NotifyPage extends StatefulWidget {
  const NotifyPage({super.key});
  @override
  State<NotifyPage> createState() => _NotifyPageState();
}

class _NotifyPageState extends State<NotifyPage> {
  final _titleCtl = TextEditingController();
  final _bodyCtl  = TextEditingController();
  List _users = [];
  Set _selected = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Map<String,String> _hdr() {
    // TODO: replace with real auth token header
    return {'Authorization':'Bearer demo','Content-Type':'application/json'};
  }

  Future<void> _loadUsers() async {
    final res = await http.get(Uri.parse('/admin/users'), headers: _hdr());
    setState(() {
      _users = jsonDecode(res.body);
      _loading = false;
    });
  }

  Future<void> _send() async {
    final ids = _selected.toList();
    await http.post(Uri.parse('/admin/notify'),
      headers: _hdr(),
      body: jsonEncode({
        'title': _titleCtl.text,
        'body' : _bodyCtl.text,
        'userIds': ids,
      }),
    );
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Notification sent')));
    _titleCtl.clear(); _bodyCtl.clear(); _selected.clear();
    setState((){});
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(controller: _titleCtl, decoration: const InputDecoration(labelText: 'Title')),
          const SizedBox(height:8),
          TextField(controller: _bodyCtl, maxLines:3, decoration: const InputDecoration(labelText: 'Body')),
          const SizedBox(height:8),
          ElevatedButton(
            onPressed: () async {
              final res = await showDialog<Set>(
                context: context,
                builder: (_) => _UserSelectDialog(_users, _selected),
              );
              if (res != null) setState(() => _selected = res);
            },
            child: Text('Select users (${_selected.length})'),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: _selected.isEmpty ? null : _send,
            child: const Text('SEND'),
          ),
        ],
      ),
    );
  }
}

class _UserSelectDialog extends StatefulWidget {
  final List users;
  final Set selected;
  const _UserSelectDialog(this.users, this.selected);

  @override
  State<_UserSelectDialog> createState() => _UserSelectDialogState();
}

class _UserSelectDialogState extends State<_UserSelectDialog> {
  late Set sel;
  @override void initState() { sel = {...widget.selected}; super.initState(); }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select recipients'),
      content: SizedBox(
        width: 300, height: 400,
        child: ListView(
          children: widget.users.map<Widget>((u) {
            return CheckboxListTile(
              value: sel.contains(u['id']),
              title: Text(u['email']),
              onChanged: (v){
                setState(()=> v! ? sel.add(u['id']) : sel.remove(u['id']));
              },
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(onPressed: ()=>Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(onPressed: ()=>Navigator.pop(context, sel), child: const Text('OK')),
      ],
    );
  }
}
