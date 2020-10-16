const { environment } = require('@rails/webpacker')

environment.splitChunks()

environment.loaders.append('jquery', {
  test: require.resolve('jquery'),
  rules: [
    {
      loader: 'expose-loader',
      options: {
        exposes: ['$', 'jQuery'],
      },
    },
  ],
});

environment.loaders.append('clipboard', {
  test: require.resolve('clipboard'),
  rules: [
    {
      loader: 'expose-loader',
      options: {
        exposes: ['ClipboardJS'],
      },
    },
  ],
});

module.exports = environment
