// javascripts
require('@rails/ujs').start()
require('turbolinks').start()

import 'simplebar'
import 'javascripts/app.init'
import 'javascripts/app.tooltip'
import 'javascripts/app.gtrends'

// stylesheets
import 'stylesheets/application'

// images
const images = require.context('../images', true)
const imagePath = (name) => images(name, true)
