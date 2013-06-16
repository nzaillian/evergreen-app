if Figaro.env["exception_recipient"] && Figaro.env["exception_sender"]
  Rails.application.config.middleware.use(ExceptionNotifier,

      email_prefix: "[Evergreen App Notifier] ",
      sender_address: Figaro.env.exception_sender,
      exception_recipients: [Figaro.env.exception_recipient]
  )
end