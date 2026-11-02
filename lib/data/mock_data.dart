import 'package:flutter/material.dart';

import 'models.dart';

abstract final class MockData {
  static const avatarPalette = [
    Color(0xFF1B63FF),
    Color(0xFF7C5CFF),
    Color(0xFF0FA968),
    Color(0xFFF59E0B),
    Color(0xFFEC4899),
    Color(0xFF0EA5E9),
  ];

  static const leads = <Lead>[
    Lead(
      id: 'l1',
      name: 'Marina Alves',
      phone: '(11) 98844-1200',
      city: 'São Paulo · SP',
      interest: 'Honda CG 160',
      image: 'assets/images/bike_naked.jpg',
      source: LeadSource.instagram,
      timeAgo: 'há 2 min',
      temperature: LeadTemperature.hot,
      tags: ['Financiamento', 'Primeira moto'],
      note:
          'Escolheu a CG 160 2024 azul e quer financiar. Enviou o CPF para a simulação.',
      avatarColor: Color(0xFF1B63FF),
      cpf: '123.456.789-09',
      email: 'marina.alves@gmail.com',
      birthDate: '14/03/1996',
      profession: 'Designer gráfico',
      address: 'Rua Cardeal Arcoverde, 1210 · Pinheiros',
      plate: 'QFX-2C45',
      bikeYear: '2024',
      bikeKm: '0 km',
    ),
    Lead(
      id: 'l2',
      name: 'Rafael Souza',
      phone: '(11) 97722-0811',
      city: 'Guarulhos · SP',
      interest: 'Yamaha YZF-R3',
      image: 'assets/images/bike_yellow.jpg',
      source: LeadSource.whatsapp,
      timeAgo: 'há 6 min',
      temperature: LeadTemperature.hot,
      tags: ['Troca', 'À vista'],
      note: 'Tem uma Fazer 250 2021 para trocar. Pediu avaliação da usada.',
      avatarColor: Color(0xFF0FA968),
      cpf: '987.654.321-00',
      email: 'rafa.souza@outlook.com',
      birthDate: '02/11/1992',
      profession: 'Motorista de app',
      address: 'Av. Guarulhos, 2145 · Centro',
      plate: 'KTZ-1B77',
      bikeYear: '2023',
      bikeKm: '8.400 km',
    ),
    Lead(
      id: 'l3',
      name: 'Camila Ribeiro',
      phone: '(11) 96633-4410',
      city: 'Osasco · SP',
      interest: 'Royal Enfield Hunter 350',
      image: 'assets/images/bike_cruiser.jpg',
      source: LeadSource.site,
      timeAgo: 'há 11 min',
      temperature: LeadTemperature.warm,
      tags: ['Financiamento'],
      note: 'Veio pelo site, quer saber o valor da parcela em 36x sem entrada.',
      avatarColor: Color(0xFF7C5CFF),
      cpf: '456.789.123-32',
      email: 'camila.ribeiro@yahoo.com.br',
      birthDate: '30/07/1998',
      profession: 'Analista financeiro',
      address: 'Rua das Palmeiras, 88 · Cidade Nova',
      plate: 'PBD-7K33',
      bikeYear: '2024',
      bikeKm: '1.200 km',
    ),
    Lead(
      id: 'l4',
      name: 'Bruno Martins',
      phone: '(11) 95511-9022',
      city: 'São Bernardo · SP',
      interest: 'Honda XRE 300',
      image: 'assets/images/bike_orange.jpg',
      source: LeadSource.instagram,
      timeAgo: 'há 18 min',
      temperature: LeadTemperature.warm,
      tags: ['Troca', 'Financiamento'],
      note: 'Usa a moto para trabalhar. Prioriza conforto e baixo consumo.',
      avatarColor: Color(0xFFEC4899),
      cpf: '234.567.891-01',
      email: 'brunomartins@gmail.com',
      birthDate: '19/05/1990',
      profession: 'Entregador autônomo',
      address: 'Rua Ferraz, 512 · Assunção',
      plate: 'MTR-3F90',
      bikeYear: '2022',
      bikeKm: '22.100 km',
    ),
    Lead(
      id: 'l5',
      name: 'Larissa Gomes',
      phone: '(11) 94488-7133',
      city: 'Santo André · SP',
      interest: 'Yamaha Fazer 250',
      image: 'assets/images/bike_naked.jpg',
      source: LeadSource.store,
      timeAgo: 'há 24 min',
      temperature: LeadTemperature.hot,
      tags: ['Primeira moto', 'Financiamento'],
      note:
          'Passou na loja ontem, gostou da Fazer azul. Vai decidir até sexta.',
      avatarColor: Color(0xFFF59E0B),
      cpf: '876.543.219-88',
      email: 'lari.gomes@icloud.com',
      birthDate: '07/09/2001',
      profession: 'Estudante',
      address: 'Rua Piauí, 77 · Parque das Nações',
      plate: 'FDE-8H21',
      bikeYear: '2023',
      bikeKm: '0 km',
    ),
    Lead(
      id: 'l6',
      name: 'Diego Fernandes',
      phone: '(11) 93377-2288',
      city: 'São Paulo · SP',
      interest: 'Kawasaki Ninja 400',
      image: 'assets/images/bike_red.jpg',
      source: LeadSource.whatsapp,
      timeAgo: 'há 32 min',
      temperature: LeadTemperature.warm,
      tags: ['À vista'],
      note: 'Já tem o valor separado. Quer ver as opções de cor disponíveis.',
      avatarColor: Color(0xFF0EA5E9),
      cpf: '345.678.912-45',
      email: 'diegofernandes@gmail.com',
      birthDate: '28/12/1994',
      profession: 'Professor',
      address: 'Rua Banibas, 301 · Saúde',
      plate: 'GNW-5P84',
      bikeYear: '2023',
      bikeKm: '5.200 km',
    ),
    Lead(
      id: 'l7',
      name: 'Patrícia Lima',
      phone: '(11) 92266-5511',
      city: 'Diadema · SP',
      interest: 'Honda PCX 160',
      image: 'assets/images/bike_naked.jpg',
      source: LeadSource.site,
      timeAgo: 'há 41 min',
      temperature: LeadTemperature.cold,
      tags: ['Financiamento'],
      note: 'Pesquisando preço. Respondeu que vai olhar no fim do mês.',
      avatarColor: Color(0xFF7C5CFF),
      cpf: '567.891.234-77',
      email: 'patricia.lima@hotmail.com',
      birthDate: '11/01/1987',
      profession: 'Recepcionista',
      address: 'Av. Antônio Piranga, 4000 · Eldorado',
      plate: 'RQS-2J10',
      bikeYear: '2022',
      bikeKm: '18.900 km',
    ),
    Lead(
      id: 'l8',
      name: 'Thiago Nunes',
      phone: '(11) 91155-0044',
      city: 'Barueri · SP',
      interest: 'BMW G 310 R',
      image: 'assets/images/bike_naked.jpg',
      source: LeadSource.instagram,
      timeAgo: 'há 55 min',
      temperature: LeadTemperature.warm,
      tags: ['Troca', 'Financiamento'],
      note: 'Quer avaliar a moto atual antes de fechar negócio.',
      avatarColor: Color(0xFF0FA968),
      cpf: '678.912.345-22',
      email: 'thiagonunes@gmail.com',
      birthDate: '23/06/1993',
      profession: 'Encanador',
      address: 'Al. Rio Negro, 1055 · Alphaville',
      plate: 'SVA-4R55',
      bikeYear: '2022',
      bikeKm: '12.600 km',
    ),
    Lead(
      id: 'l9',
      name: 'Juliana Castro',
      phone: '(11) 90044-8899',
      city: 'São Paulo · SP',
      interest: 'Yamaha MT-03',
      image: 'assets/images/bike_yellow.jpg',
      source: LeadSource.store,
      timeAgo: 'há 1 h',
      temperature: LeadTemperature.hot,
      tags: ['Primeira moto'],
      note: 'Fez test ride e saiu encantada. Falta aprovação do financiamento.',
      avatarColor: Color(0xFFEC4899),
      cpf: '789.123.456-64',
      email: 'juliana.castro@gmail.com',
      birthDate: '05/10/1999',
      profession: 'Enfermeira',
      address: 'Rua Topázio, 238 · Itaim Bibi',
      plate: 'TCC-9M31',
      bikeYear: '2024',
      bikeKm: '0 km',
    ),
    Lead(
      id: 'l10',
      name: 'Felipe Araújo',
      phone: '(11) 98800-1122',
      city: 'Cotia · SP',
      interest: 'Honda CB 650R',
      image: 'assets/images/bike_naked.jpg',
      source: LeadSource.site,
      timeAgo: 'há 2 h',
      temperature: LeadTemperature.cold,
      tags: ['À vista', 'Troca'],
      note:
          'Comparando com concessionária da região. Pediu proposta por e-mail.',
      avatarColor: Color(0xFF1B63FF),
      cpf: '890.234.567-55',
      email: 'felipearaujo@gmail.com',
      birthDate: '17/02/1985',
      profession: 'Comerciante',
      address: 'Rua Mem de Sá, 66 · Jardim das Rosas',
      plate: 'WKM-6T18',
      bikeYear: '2021',
      bikeKm: '30.400 km',
    ),
  ];

  static final attendances = <Attendance>[
    Attendance(
      lead: leads[0],
      status: AttendanceStatus.active,
      elapsed: '12 min com você',
    ),
    Attendance(
      lead: leads[3],
      status: AttendanceStatus.active,
      elapsed: '48 min com você',
    ),
    Attendance(
      lead: leads[8],
      status: AttendanceStatus.active,
      elapsed: '2 h com você',
    ),
    Attendance(
      lead: leads[5],
      status: AttendanceStatus.active,
      elapsed: '3 h com você',
    ),
    Attendance(
      lead: leads[2],
      status: AttendanceStatus.scheduled,
      elapsed: 'Agendado há 1 dia',
      schedule: 'Sáb, 10:30 · Test ride',
    ),
    Attendance(
      lead: leads[7],
      status: AttendanceStatus.scheduled,
      elapsed: 'Agendado há 2 dias',
      schedule: 'Hoje, 17:00 · Avaliação',
    ),
    Attendance(
      lead: leads[4],
      status: AttendanceStatus.scheduled,
      elapsed: 'Agendado há 3 dias',
      schedule: 'Seg, 09:00 · Retorno',
    ),
    Attendance(
      lead: leads[6],
      status: AttendanceStatus.closed,
      elapsed: 'Encerrado há 1 h',
      closedReason: 'Sem interesse no momento',
    ),
    Attendance(
      lead: leads[9],
      status: AttendanceStatus.closed,
      elapsed: 'Encerrado ontem',
      closedReason: 'Comprou em outra loja',
    ),
  ];

  static const bikes = <Bike>[
    Bike(
      id: 'b1',
      name: 'Honda CB 500X',
      brand: 'Honda',
      category: 'Adventure',
      price: 38490,
      monthly: 749,
      year: '2024',
      km: '0 km',
      cc: '471 cc',
      image: 'assets/images/bike_orange.jpg',
      badge: '0 km',
      colors: [Color(0xFFE04A2F), Color(0xFF1B1B1F), Color(0xFFD7D9DE)],
      description:
          'A adventure mais versátil da categoria. Posição de pilotagem confortável, suspensão de curso longo e motor bicilíndrico com entrega suave.',
    ),
    Bike(
      id: 'b2',
      name: 'Yamaha YZF-R3',
      brand: 'Yamaha',
      category: 'Esportiva',
      price: 34990,
      monthly: 689,
      year: '2023',
      km: '8.400 km',
      cc: '321 cc',
      image: 'assets/images/bike_yellow.jpg',
      badge: 'Oferta',
      colors: [Color(0xFFF2B705), Color(0xFF1B1B1F), Color(0xFF2F6BFF)],
      description:
          'Esportiva de entrada com DNA R-Series. Motor bicilíndrico, carenagem aerodinâmica e ciclística leve para o dia a dia e para a pista.',
    ),
    Bike(
      id: 'b3',
      name: 'KTM RC 390',
      brand: 'KTM',
      category: 'Esportiva',
      price: 39900,
      monthly: 799,
      year: '2024',
      km: '0 km',
      cc: '373 cc',
      image: 'assets/images/bike_ktm.jpg',
      badge: 'Novo',
      colors: [Color(0xFFF2F2F2), Color(0xFFF06A1E), Color(0xFF1B1B1F)],
      description:
          'Naked esportiva com chassi de treliça, suspensão WP e eletrônica de série. Feita para quem gosta de performance e presença.',
    ),
    Bike(
      id: 'b4',
      name: 'Kawasaki Ninja 400',
      brand: 'Kawasaki',
      category: 'Esportiva',
      price: 36500,
      monthly: 719,
      year: '2023',
      km: '5.200 km',
      cc: '399 cc',
      image: 'assets/images/bike_red.jpg',
      badge: 'Seminova',
      colors: [Color(0xFFC1121F), Color(0xFF1B1B1F), Color(0xFF2F6BFF)],
      description:
          'A esportiva mais equilibrada da categoria. Motor bicilíndrico de 45 cv, embreagem assistida e visual inspirado na linha Ninja.',
    ),
    Bike(
      id: 'b5',
      name: 'Royal Enfield Hunter 350',
      brand: 'Royal Enfield',
      category: 'Custom',
      price: 21990,
      monthly: 449,
      year: '2024',
      km: '1.200 km',
      cc: '349 cc',
      image: 'assets/images/bike_cruiser.jpg',
      badge: 'Oferta',
      colors: [Color(0xFF2F2A26), Color(0xFF7A1F1F), Color(0xFFE6E2D8)],
      description:
          'Estilo retrô com pegada urbana. Motor monocilíndrico de torque alto, posição confortável e um visual que não passa despercebido.',
    ),
    Bike(
      id: 'b6',
      name: 'BMW G 310 R',
      brand: 'BMW',
      category: 'Street',
      price: 32900,
      monthly: 639,
      year: '2022',
      km: '12.600 km',
      cc: '313 cc',
      image: 'assets/images/bike_naked.jpg',
      badge: 'Usada',
      colors: [Color(0xFF1B1B1F), Color(0xFFD7D9DE), Color(0xFF1B63FF)],
      description:
          'Street premium com motor monocilíndrico refrigerado a líquido. Ideal para quem quer agilidade na cidade com o acabamento BMW.',
    ),
    Bike(
      id: 'b7',
      name: 'Honda CG 160',
      brand: 'Honda',
      category: 'Street',
      price: 18990,
      monthly: 389,
      year: '2024',
      km: '0 km',
      cc: '160 cc',
      image: 'assets/images/bike_naked.jpg',
      badge: '0 km',
      colors: [Color(0xFF1B63FF), Color(0xFF1B1B1F), Color(0xFFD7D9DE)],
      description:
          'A moto mais vendida do Brasil. Econômica, leve e barata de manutenção. Ideal para o dia a dia no trânsito e para o trabalho.',
    ),
  ];

  static const afterSales = <AfterSale>[
    AfterSale(
      name: 'Ana Beatriz',
      bike: 'Honda CG 160',
      image: 'assets/images/bike_cruiser.jpg',
      purchased: 'há 3 dias',
      followUp: 'Hoje · 14:00',
      avatarColor: Color(0xFFEC4899),
      rating: 5,
    ),
    AfterSale(
      name: 'Marcos Paulo',
      bike: 'Yamaha Factor 150',
      image: 'assets/images/bike_naked.jpg',
      purchased: 'há 1 semana',
      followUp: 'Hoje · 16:30',
      avatarColor: Color(0xFF1B63FF),
      rating: 5,
    ),
    AfterSale(
      name: 'Renata Dias',
      bike: 'Honda PCX 160',
      image: 'assets/images/bike_naked.jpg',
      purchased: 'há 2 semanas',
      followUp: 'Amanhã · 10:00',
      avatarColor: Color(0xFF0FA968),
      rating: 4,
    ),
    AfterSale(
      name: 'Carlos Eduardo',
      bike: 'Yamaha XTZ 250',
      image: 'assets/images/bike_orange.jpg',
      purchased: 'há 1 mês',
      followUp: '05 nov · 09:30',
      avatarColor: Color(0xFFF59E0B),
      rating: 5,
    ),
    AfterSale(
      name: 'Sofia Mendes',
      bike: 'Kawasaki Ninja 400',
      image: 'assets/images/bike_red.jpg',
      purchased: 'há 1 mês',
      followUp: '08 nov · 15:00',
      avatarColor: Color(0xFF7C5CFF),
      rating: 5,
    ),
  ];

  static List<ChatMessage> chatFor(Lead lead, AttendanceStatus? status) {
    final messages = _baseChat(lead);
    if (status == null) return messages;
    messages.addAll(consultantChat(lead));
    return messages;
  }

  static List<ChatMessage> _baseChat(Lead lead) {
    final bike = bikeFor(lead.interest);
    final price = bike?.price ?? 18990;
    final monthly = bike?.monthly ?? (price ~/ 49);
    final messages = <ChatMessage>[
      const ChatMessage(
        text: 'Oi! Boa tarde 😊',
        time: '09:41',
        fromLead: true,
      ),
      ChatMessage(
        text: 'Vi o anúncio da ${lead.interest} no ${lead.source.label}',
        time: '09:41',
        fromLead: true,
      ),
      const ChatMessage(
        text: 'Queria saber o valor dela',
        time: '09:42',
        fromLead: true,
      ),
      const ChatMessage(
        text: 'Separei 3 opções pra você:',
        time: '09:42',
        fromLead: false,
        automated: true,
        kind: ChatMessageKind.bikes,
      ),
      ChatMessage(
        text: 'Gostei da ${lead.interest} 2024 azul. Dá pra financiar?',
        time: '09:44',
        fromLead: true,
      ),
      ChatMessage(
        text:
            'Claro! 💳 Com entrada de R\$ 1.200, fica em 36x de '
            '${money(monthly)}. Quer seguir?',
        time: '09:44',
        fromLead: false,
        automated: true,
      ),
      const ChatMessage(text: 'Quero sim!', time: '09:45', fromLead: true),
      const ChatMessage(
        text: 'Perfeito! Me envia seu CPF que já faço a simulação. 🔒',
        time: '09:45',
        fromLead: false,
        automated: true,
      ),
      ChatMessage(text: lead.cpf, time: '09:46', fromLead: true),
      const ChatMessage(
        text: 'Qual a placa da moto que eu escolhi?',
        time: '09:46',
        fromLead: true,
      ),
      ChatMessage(
        text:
            'Anotado! A placa da ${lead.interest} 2024 é ${lead.plate}. '
            'Um consultor já vai te chamar. 🏍️',
        time: '09:47',
        fromLead: false,
        automated: true,
      ),
    ];

    return messages;
  }

  static List<ChatMessage> consultantChat(Lead lead) => [
    ChatMessage(
      text:
          'Oi, ${lead.firstName}! Aqui é o Gustavo, consultor da Acelera 🏍️',
      time: '09:50',
      fromLead: false,
    ),
    ChatMessage(
      text:
          'Recebi sua simulação da ${lead.interest} 2024 e já separei ela pra você.',
      time: '09:50',
      fromLead: false,
    ),
    const ChatMessage(
      text: 'Moto separada 👇',
      time: '09:51',
      fromLead: false,
      kind: ChatMessageKind.bike,
    ),
    const ChatMessage(
      text: 'Perfeito! Consigo passar aí sábado?',
      time: '09:52',
      fromLead: true,
    ),
    const ChatMessage(
      text: 'Fechado! Te espero às 10:30 com ela separada. 🏁',
      time: '09:53',
      fromLead: false,
      read: false,
    ),
  ];

  static Bike? bikeFor(String name) {
    for (final bike in bikes) {
      if (bike.name == name) return bike;
    }
    return null;
  }

  static String money(int value) {
    final digits = value.toString();
    final buffer = StringBuffer('R\$ ');
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buffer.write('.');
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }

  static final Map<String, List<CpfSimulation>> _simulations = {
    'l1': [
      CpfSimulation(
        cpf: '123.456.789-09',
        status: CreditStatus.approved,
        time: '09:48',
        bank: 'Banco Inter',
      ),
      CpfSimulation(
        cpf: '111.222.333-44',
        status: CreditStatus.rejected,
        time: '09:49',
        bank: 'Banco Pan',
      ),
      CpfSimulation(cpf: '555.666.777-88', time: '09:52'),
    ],
    'l3': [
      CpfSimulation(
        cpf: '456.789.123-32',
        status: CreditStatus.approved,
        time: '09:20',
        bank: 'Banco Inter',
      ),
    ],
    'l4': [
      CpfSimulation(
        cpf: '234.567.891-01',
        status: CreditStatus.rejected,
        time: '08:55',
        bank: 'Banco Pan',
      ),
    ],
    'l5': [CpfSimulation(cpf: '876.543.219-88', time: '09:10')],
    'l7': [CpfSimulation(cpf: '567.891.234-77', time: '08:40')],
    'l8': [
      CpfSimulation(
        cpf: '678.912.345-22',
        status: CreditStatus.approved,
        time: '08:30',
        bank: 'Nubank',
      ),
    ],
    'l9': [CpfSimulation(cpf: '789.123.456-64', time: '09:05')],
  };

  static List<CpfSimulation> simulationsFor(Lead lead) =>
      _simulations[lead.id] ?? const <CpfSimulation>[];

  static CreditStatus creditStatusFor(Lead lead, String cpf) {
    for (final sim in simulationsFor(lead)) {
      if (sim.cpf == cpf) return sim.status;
    }
    return CreditStatus.pending;
  }

  static void setCreditStatus(Lead lead, String cpf, CreditStatus status) {
    final list = _simulations.putIfAbsent(lead.id, () => <CpfSimulation>[]);
    final index = list.indexWhere((sim) => sim.cpf == cpf);
    if (index >= 0) {
      list[index].status = status;
    } else {
      list.add(CpfSimulation(cpf: cpf, status: status, time: 'agora'));
    }
  }

  static void addCpf(Lead lead, String cpf) {
    final list = _simulations.putIfAbsent(lead.id, () => <CpfSimulation>[]);
    if (list.any((sim) => sim.cpf == cpf)) return;
    list.add(CpfSimulation(cpf: cpf, time: 'agora'));
  }

  static bool hasApproved(Lead lead) =>
      simulationsFor(lead).any((sim) => sim.status == CreditStatus.approved);

  static bool hasRejected(Lead lead) =>
      simulationsFor(lead).any((sim) => sim.status == CreditStatus.rejected);

  static bool hasPending(Lead lead) =>
      simulationsFor(lead).any((sim) => sim.status == CreditStatus.pending);

  static final featuredBike = bikes[3];
  static const newLeadsToday = 12;
  static const assumedToday = 7;
  static const salesToday = 1;
  static const nps = 92;
  static const responseTime = '1m 42s';
}
