const { getClient, setJwtToken } = require("./apolloHelper");
const { gql } = require("@apollo/client");
const crypto = require("crypto");
let aClient, first_username, second_username, password, jwtToken, first_userid, second_userid, postid;
beforeAll(() => {
  aClient = getClient();
  first_username = `${crypto.randomBytes(7).toString("hex")}@${crypto
    .randomBytes(4)
    .toString("hex")}.com`;
    second_username = `${crypto.randomBytes(7).toString("hex")}@${crypto
      .randomBytes(4)
      .toString("hex")}.com`;
  password = "testPass";
});

describe("Check Row Level Security", () => {
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
          username: first_username,
          password: password,
        },
      });
      expect(result.data.registerUser.user.id).not.toEqual(null);
      first_userid = result.data.registerUser.user.id;
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
            username: first_username,
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
                userid: first_userid,
            },
        });
        expect(res.data.updateUser.user.aboutme).not.toEqual(null);
    });

    it("Create Post", async () => {
      let res = await aClient.mutate({
        mutation: gql`
          mutation createPost {
            createPost(
              input: {
                post: {
                  body: "What's the difference between JavaScript and Java?"
                  posttypeid: 1
                  tags: "brewing"
                  title: "What's the difference between JavaScript and Java?"
                }
              }
            ) {
              post {
                id
                tags
                title
                body
              }
            }
          }
        `,
      });
      postid = res.data.createPost.post.id;
      expect(res.data.createPost.post.id).not.toEqual(null);
      setJwtToken(null);
    });

    it("Register 2nd User", async () => {
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
          username: second_username,
          password: password,
        },
      });
      expect(result.data.registerUser.user.id).not.toEqual(null);
      second_userid = result.data.registerUser.user.id;
    });

    it("Authenticate 2nd User", async () => {
      let res = await aClient.mutate({
        mutation: gql`
          mutation auth($username: String!, $password: String!) {
            authenticate(input: { username: $username, password: $password }) {
              jwtToken
            }
          }
        `,
        variables: {
          username: second_username,
          password: password,
        },
      });
      expect(res.data.authenticate.jwtToken).not.toEqual(null);
      setJwtToken(res.data.authenticate.jwtToken);
  });

  it("Attempt to Update First User's aboutMe", async () => {
    let res = await aClient.mutate({
        mutation: gql `
            mutation setabout($userid: Int!) {
                updateUser(
                    input: {
                        id: $userid
                        patch: {
                            aboutme: "Hello Security Breach"
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
            userid: first_userid,
        },
    });
    expect(res.data.updateUser).toEqual(null);
  });

    it("Attempt to Update First User's Post", async () => {
      let res = await aClient.mutate({
          mutation: gql `
              mutation setPost($postid: Int!) {
                  updatePost(
                      input: {
                          id: $postid
                          patch: {
                              title: "Hello Security Breach"
                          }
                      }
                  ){
                      post {
                          id
                          title
                      }
                  }
              }
          `,
          variables: {
              postid: postid,
          },
      });
      expect(res.data.updatePost).toEqual(null);
    });
  
});

afterAll(() => {
    console.log(
      `Username: ${first_username} \n Password: ${password} \n JwtToken: ${jwtToken}`
    );
});