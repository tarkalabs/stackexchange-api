const nodemailer = require("nodemailer");
let smtpTransport;
module.exports = {
  initilaize() {
    if (
      process.env.MAILER_SMTP_HOST &&
      process.env.MAILER_SMTP_PASSWORD &&
      process.env.MAILER_SMTP_PORT &&
      process.env.MAILER_SMTP_USERNAME
    ) {
      smtpTransport = nodemailer.createTransport({
        host: process.env.MAILER_SMTP_HOST,
        port: Number(process.env.MAILER_SMTP_PORT),
        auth: {
          user: process.env.MAILER_SMTP_USERNAME,
          pass: process.env.MAILER_SMTP_PASSWORD,
        },
      });
      console.log("SMTP server config found. Mailer plugin available");
    } else {
      console.log("SMTP server config not found. Mailer plugin not available.");
    }
  },
  async sendMail(emailAddr) {
    let body = compileEmail`<p><b>Welcome to Stackexchange API!</b></p><p>You registered with email address ${emailAddr}</p>`;
    if (smtpTransport) {
      await smtpTransport.sendMail({
        from: "test@test.com",
        to: emailAddr,
        subject: "Welcome to Stackexchange API",
        html: body,
      });
    }
  },
};

function compileEmail(template, emailAddr) {
  return template[0] + emailAddr + template[1];
}
