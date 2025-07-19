String getFullImageUrl(String? url) {
  if (url == null || url.isEmpty) return '';
  if (url.startsWith('http://') || url.startsWith('https://')) return url;
  return 'https://res.cloudinary.com/dkiuz3gfn/image/upload/v1/$url';
}
