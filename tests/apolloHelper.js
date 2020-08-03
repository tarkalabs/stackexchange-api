const {
  ApolloClient,
  createHttpLink,
  InMemoryCache,
} = require("@apollo/client");
const { setContext } = require("@apollo/client/link/context");
const fetch = require("cross-fetch");
let client, jwtToken;
const httpLink = createHttpLink({
  uri: "http://localhost:3000/graphql",
  fetch,
});

const authLink = setContext((_, { headers }) => {
  if (jwtToken) {
    return {
      headers: {
        ...headers,
        authorization: `Bearer ${jwtToken}`,
      },
    };
  }
  return {
    headers: {
      ...headers,
    },
  };
});

module.exports = {
  getClient() {
    if (client) {
      return client;
    }
    client = new ApolloClient({
      link: authLink.concat(httpLink),
      cache: new InMemoryCache(),
    });
    return client;
  },
  setJwtToken(token) {
    jwtToken = token;
  },
};
