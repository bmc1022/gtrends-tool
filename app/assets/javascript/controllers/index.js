import { application } from "./application"

import GtrendController from "./gtrend_controller"
application.register("gtrend", GtrendController)

import TooltipController from "./tooltip_controller"
application.register("tooltip", TooltipController)
