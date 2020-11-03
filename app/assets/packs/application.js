import $ from 'jquery'
global.$ = $

// javascripts
require('@rails/ujs').start()
require('turbolinks').start()

import 'jquery'
import 'popper.js'
import 'bootstrap'
import 'clipboard'
import 'simplebar'
import 'javascripts/app.init'
import 'javascripts/app.tooltip'

// stylesheets
import 'stylesheets/application'

// images
const images = require.context('../images', true)
const imagePath = (name) => images(name, true)
