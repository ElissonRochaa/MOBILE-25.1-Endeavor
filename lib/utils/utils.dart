String limitarTexto(String texto, int maxCaracteres) {
  if (texto.length <= maxCaracteres) {
    return texto;
  } else {
    return '${texto.substring(0, maxCaracteres)}...';
  }
}
