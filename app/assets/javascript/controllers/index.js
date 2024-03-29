import { application } from "./application";

import AlertController from "./alert_controller";
application.register("alert", AlertController);

import ClipboardController from "./clipboard_controller";
application.register("clipboard", ClipboardController);

import FormController from "./form_controller";
application.register("form", FormController);

import GtrendController from "./gtrend_controller";
application.register("gtrend", GtrendController);

import SimplebarController from "./simplebar_controller";
application.register("simplebar", SimplebarController);

import TooltipController from "./tooltip_controller";
application.register("tooltip", TooltipController);

import consumer from "../channels/consumer";
application.consumer = consumer;
