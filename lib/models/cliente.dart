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

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      codigo: json['codigo'] != null
          ? int.parse(json['codigo'].toString())
          : null,
      nome: json['nome']?.toString() ?? '',
      endereco: json['endereco']?.toString() ?? '',
      telefone: json['telefone']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'nome': nome,
      'endereco': endereco,
      'telefone': telefone,
    };

    // Só inclui código se for para UPDATE (não para CREATE)
    if (codigo != null && codigo! > 0) {
      data['codigo'] = codigo;
    }

    return data;
  }
}
