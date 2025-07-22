import 'package:flutter/material.dart';
import 'models/cliente.dart';
import 'services/cliente_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD Clientes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const ClientesScreen(),
    );
  }
}

class ClientesScreen extends StatefulWidget {
  const ClientesScreen({super.key});

  @override
  State<ClientesScreen> createState() => _ClientesScreenState();
}

class _ClientesScreenState extends State<ClientesScreen> {
  List<Cliente> _clientes = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _carregarClientes();
  }

  Future<void> _carregarClientes() async {
    setState(() => _loading = true);
    final clientes = await ClienteService.getClientes();
    setState(() {
      _clientes = clientes;
      _loading = false;
    });
  }

  Future<void> _adicionarCliente(Cliente cliente) async {
    final sucesso = await ClienteService.createCliente(cliente);
    if (sucesso) {
      _carregarClientes();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cliente adicionado com sucesso!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao adicionar cliente')),
      );
    }
  }

  Future<void> _editarCliente(Cliente cliente) async {
    final sucesso = await ClienteService.updateCliente(cliente);
    if (sucesso) {
      _carregarClientes();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cliente atualizado com sucesso!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao atualizar cliente')),
      );
    }
  }

  Future<void> _excluirCliente(int codigo) async {
    final sucesso = await ClienteService.deleteCliente(codigo);
    if (sucesso) {
      _carregarClientes();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cliente excluído com sucesso!')),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Erro ao excluir cliente')));
    }
  }

  void _mostrarFormulario({Cliente? cliente}) {
    showDialog(
      context: context,
      builder: (context) => ClienteFormDialog(
        cliente: cliente,
        onSalvar: (novoCliente) {
          if (cliente == null) {
            _adicionarCliente(novoCliente);
          } else {
            _editarCliente(novoCliente);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CRUD Clientes'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _carregarClientes,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _clientes.isEmpty
          ? const Center(
              child: Text(
                'Nenhum cliente cadastrado',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: _clientes.length,
              itemBuilder: (context, index) {
                final cliente = _clientes[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    leading: CircleAvatar(child: Text('${cliente.codigo}')),
                    title: Text(
                      cliente.nome,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('📍 ${cliente.endereco}'),
                        Text('📞 ${cliente.telefone}'),
                      ],
                    ),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _mostrarFormulario(cliente: cliente),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: cliente.codigo != null
                              ? () => _excluirCliente(cliente.codigo!)
                              : null,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarFormulario(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ClienteFormDialog extends StatefulWidget {
  final Cliente? cliente;
  final Function(Cliente) onSalvar;

  const ClienteFormDialog({super.key, this.cliente, required this.onSalvar});

  @override
  State<ClienteFormDialog> createState() => _ClienteFormDialogState();
}

class _ClienteFormDialogState extends State<ClienteFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _codigoController;
  late TextEditingController _nomeController;
  late TextEditingController _enderecoController;
  late TextEditingController _telefoneController;

  @override
  void initState() {
    super.initState();
    _codigoController = TextEditingController(
      text: widget.cliente?.codigo.toString() ?? '',
    );
    _nomeController = TextEditingController(text: widget.cliente?.nome ?? '');
    _enderecoController = TextEditingController(
      text: widget.cliente?.endereco ?? '',
    );
    _telefoneController = TextEditingController(
      text: widget.cliente?.telefone ?? '',
    );
  }

  @override
  void dispose() {
    _codigoController.dispose();
    _nomeController.dispose();
    _enderecoController.dispose();
    _telefoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.cliente == null ? 'Novo Cliente' : 'Editar Cliente'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _codigoController,
              decoration: const InputDecoration(labelText: 'Código'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Código é obrigatório';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _nomeController,
              decoration: const InputDecoration(labelText: 'Nome'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nome é obrigatório';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _enderecoController,
              decoration: const InputDecoration(labelText: 'Endereço'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Endereço é obrigatório';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _telefoneController,
              decoration: const InputDecoration(labelText: 'Telefone'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Telefone é obrigatório';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final cliente = Cliente(
                codigo:
                    widget.cliente?.codigo, // Só usa código se estiver editando
                nome: _nomeController.text,
                endereco: _enderecoController.text,
                telefone: _telefoneController.text,
              );
              widget.onSalvar(cliente);
              Navigator.of(context).pop();
            }
          },
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}
