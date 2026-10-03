const _bulan = [
  'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
  'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
];

String _two(int n) => n.toString().padLeft(2, '0');

String tanggalPendek(DateTime d) => '${_two(d.day)}/${_two(d.month)}/${d.year}';
String tanggalPanjang(DateTime d) => '${d.day} ${_bulan[d.month - 1]} ${d.year}';
String jam(DateTime d) => '${_two(d.hour)}:${_two(d.minute)}';
String menitDetik(int totalDetik) =>
    '${_two(totalDetik ~/ 60)}:${_two(totalDetik % 60)}';
