class Cliente {
  int? codigo;
  String nome;
  String endereco;
  String telefone;

  Cliente({
    this.codigo,
    required this.nome,
    required this.endereco,
    required this.telefone,
  });

  // Converter de Map para Cliente (usado ao ler do banco)
  factory Cliente.fromMap(Map<String, dynamic> map) {
    return Cliente(
      codigo: map['codigo'] as int?,
      nome: map['nome'] as String,
      endereco: map['endereco'] as String,
      telefone: map['telefone'] as String,
    );
  }

  // Converter de Cliente para Map (usado ao salvar no banco)
  Map<String, dynamic> toMap() {
    return {
      'codigo': codigo,
      'nome': nome,
      'endereco': endereco,
      'telefone': telefone,
    };
  }

  @override
  String toString() {
    return 'Cliente{codigo: $codigo, nome: $nome, endereco: $endereco, telefone: $telefone}';
  }
}
