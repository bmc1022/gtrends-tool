// javascripts
require('@rails/ujs').start()
require('turbolinks').start()

import 'controllers'
import 'simplebar'
import 'app.init'
import 'app.tooltip'
import 'app.gtrends'

// stylesheets
import 'stylesheets/application'

// images
const images = require.context('images', true)
const imagePath = (name) => images(name, true)
