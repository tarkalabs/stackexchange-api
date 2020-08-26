const { getClient, setJwtToken } = require("./apolloHelper");
const { gql } = require("@apollo/client");
const crypto = require("crypto");
let aClient, username, password, jwtToken, userid, badgeid;
beforeAll(() => {
  aClient = getClient();
  username = `${crypto.randomBytes(7).toString("hex")}@${crypto
    .randomBytes(4)
    .toString("hex")}.com`;
  password = "testPass";
});

describe("Acquire Badge", () => {
    it("Register User", async () => {
      let result = await aClient.mutate({
        mutation: gql`
          mutation registeruser($username: String!, $password: String!) {
            registerUser(input: { username: $username, password: $password }) {
              user {
                id
                accountid
                displayname
                views
              }
            }
          }
        `,
        variables: {
          username: username,
          password: password,
        },
      });
      expect(result.data.registerUser.user.id).not.toEqual(null);
      userid = result.data.registerUser.user.id;
    });

    it("Authenticate User", async () => {
        let res = await aClient.mutate({
          mutation: gql`
            mutation auth($username: String!, $password: String!) {
              authenticate(input: { username: $username, password: $password }) {
                jwtToken
              }
            }
          `,
          variables: {
            username: username,
            password: password,
          },
        });
        expect(res.data.authenticate.jwtToken).not.toEqual(null);
        setJwtToken(res.data.authenticate.jwtToken);
    });

    it("Set aboutMe", async () => {
        let res = await aClient.mutate({
            mutation: gql `
                mutation setabout($userid: Int!) {
                    updateUser(
                        input: {
                            id: $userid
                            patch: {
                                aboutme: "Hello World"
                            }
                        }
                    ){
                        user {
                            id
                            aboutme
                        }
                    }
                }
            `,
            variables: {
                userid: userid,
            },
        });
        expect(res.data.updateUser.user.aboutme).not.toEqual(null);
    });

    it("Check If Badge Created", async () => {
        let res = await aClient.query({
          query: gql`
            query checkbadge($userid: Int!) {
                badges(condition: {userid: $userid}) {
                  nodes {
                    id
                    name
                  }
                }
            }
          `,
          variables: {
            userid,
          },
        });
        expect(res.data.badges.nodes[0].name).toEqual('Autobiographer');
        badgeid = res.data.badges.nodes[0].id;
    });
  
});

afterAll(() => {
    console.log(
      `Username: ${username} \n Password: ${password} \n JwtToken: ${jwtToken} \n BadgeId: ${badgeid}`
    );
  });