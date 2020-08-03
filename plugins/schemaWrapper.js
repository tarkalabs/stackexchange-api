const { makeWrapResolversPlugin } = require("graphile-utils");
const { sendMail } = require("../gql-plugins/mailer");

function sendEmailOnRegister() {
  return async (resolve, source, args, context, resolveInfo) => {
    let result = await resolve();
    sendMail(args.input.username);
    return result;
  };
}

module.exports = makeWrapResolversPlugin({
  Mutation: {
    registerUser: sendEmailOnRegister(),
  },
});
