module.exports = {
  proxyList: {
	'/api': {
        target: 'http://localhost.:8080',
        hostRewrite: "localhost.:3030",
        changeOrigin: true
      }
  }
}