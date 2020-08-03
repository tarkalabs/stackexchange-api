const { getClient, setJwtToken } = require("./apolloHelper");
const { gql } = require("@apollo/client");
const crypto = require("crypto");
let aClient, username, password, jwtToken, postId, answerId, voteId;
beforeAll(() => {
  aClient = getClient();
  username = `${crypto.randomBytes(7).toString("hex")}@${crypto
    .randomBytes(4)
    .toString("hex")}.com`;
  password = "testPass";
});

describe("Make a Post", () => {
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
    postId = res.data.createPost.post.id;
    expect(res.data.createPost.post.id).not.toEqual(null);
  });

  it("Create Comment", async () => {
    let res = await aClient.mutate({
      mutation: gql`
        mutation createComment($postId: Int!) {
          createComment(
            input: {
              comment: {
                postid: $postId
                text: "Everything. They're unrelated languages"
              }
            }
          ) {
            comment {
              id
            }
          }
        }
      `,
      variables: {
        postId,
      },
    });
    expect(res.data.createComment.comment.id).not.toEqual(null);
  });

  it("Create Answer", async () => {
    let res = await aClient.mutate({
      mutation: gql`
        mutation createPostAnswer($postId: Int!) {
          createPost(
            input: {
              post: {
                parentid: $postId
                body: "Java and Javascript are similar like Car and Carpet are similar."
                posttypeid: 2
              }
            }
          ) {
            post {
              id
              body
              parentid
            }
          }
        }
      `,
      variables: {
        postId,
      },
    });
    answerId = res.data.createPost.post.id;
    expect(res.data.createPost.post.id).not.toEqual(null);
    expect(res.data.createPost.post.parentid).toEqual(postId);
  });

  it("Vote For Answer", async () => {
    let res = await aClient.mutate({
      mutation: gql`
        mutation voteAcceptAnswer($answerId: Int!) {
          createVote(input: { vote: { votetypeid: 1, postid: $answerId } }) {
            vote {
              id
            }
          }
        }
      `,
      variables: {
        answerId,
      },
    });
    voteId = res.data.createVote.vote.id;
    expect(res.data.createVote.vote.id).not.toEqual(null);
  });

  it("Check If Answer Accepted", async () => {
    let res = await aClient.query({
      query: gql`
        query post($postId: Int!) {
          post(id: $postId) {
            id
            body
            tags
            answercount
            acceptedanswerid
            commentsByPostid {
              nodes {
                text
              }
            }
          }
        }
      `,
      variables: {
        postId,
      },
    });
    expect(res.data.post.acceptedanswerid).toEqual(answerId);
    expect(res.data.post.answercount).toEqual(1);
  });

  it("Delete Answer Vote", async () => {
    let res = await aClient.mutate({
      mutation: gql`
        mutation deleteVote($voteId: Int!) {
          deleteVote(input: { id: $voteId }) {
            vote {
              id
              votetypeid
              postByPostid {
                postByParentid {
                  acceptedanswerid
                }
              }
            }
          }
        }
      `,
      variables: {
        voteId,
      },
    });
    expect(
      res.data.deleteVote.vote.postByPostid.postByParentid.acceptedanswerid
    ).toEqual(null);
  });
});

afterAll(() => {
  console.log(
    `Username: ${username} \n Password: ${password} \n PostId: ${postId} \n JwtToken: ${jwtToken} \n AnswerId: ${answerId} \n AnswerVoteId: ${voteId}`
  );
});
