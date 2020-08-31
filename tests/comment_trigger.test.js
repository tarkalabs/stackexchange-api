const { getClient, setJwtToken } = require("./apolloHelper");
const { gql } = require("@apollo/client");
const crypto = require("crypto");
let aClient, username, password, jwtToken, postId, first_commentId, second_commentId;
beforeAll(() => {
  aClient = getClient();
  username = `${crypto.randomBytes(7).toString("hex")}@${crypto
    .randomBytes(4)
    .toString("hex")}.com`;
  password = "testPass";
});

describe("Test Comment Count Trigger", () => {
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
              commentcount
            }
          }
        }
      `,
    });
    expect(res.data.createPost.post.id).not.toEqual(null);
    expect(res.data.createPost.post.commentcount).toEqual(0);
    postId = res.data.createPost.post.id;
  });

  it("Create 1st Comment", async () => {
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
              postByPostid {
                commentcount
              }
            }
          }
        }
      `,
      variables: {
        postId: postId,
      },
    });
    expect(res.data.createComment.comment.id).not.toEqual(null);
    expect(res.data.createComment.comment.postByPostid.commentcount).toEqual(1);
    first_commentId = res.data.createComment.comment.id;
  });

  it("Create 2nd Comment", async () => {
    let res = await aClient.mutate({
      mutation: gql`
        mutation createComment($postId: Int!) {
          createComment(
            input: {
              comment: {
                postid: $postId
                text: "What the other guy said."
              }
            }
          ) {
            comment {
              id
              postByPostid {
                commentcount
              }
            }
          }
        }
      `,
      variables: {
        postId: postId,
      },
    });
    expect(res.data.createComment.comment.id).not.toEqual(null);
    expect(res.data.createComment.comment.postByPostid.commentcount).toEqual(2);
    second_commentId = res.data.createComment.comment.id;
  });

  it("Delete 1st Comment", async () => {
    let res = await aClient.mutate({
      mutation: gql`
        mutation deleteComment($commentId: Int!) {
          deleteComment(input: { id: $commentId }) {
            comment {
              id
              postByPostid {
                commentcount
              }
            }
          }
        }
      `,
      variables: {
        commentId: first_commentId,
      },
    });
    expect(res.data.deleteComment.comment.postByPostid.commentcount).toEqual(1);
  });

  it("Delete 2nd Comment", async () => {
    let res = await aClient.mutate({
      mutation: gql`
        mutation deleteComment($commentId: Int!) {
          deleteComment(input: { id: $commentId }) {
            comment {
              id
              postByPostid {
                commentcount
              }
            }
          }
        }
      `,
      variables: {
        commentId: second_commentId,
      },
    });
    expect(res.data.deleteComment.comment.postByPostid.commentcount).toEqual(0);
  });

  it("Delete Non-Existent Comment", async () => {
    let res = await aClient.mutate({
      mutation: gql`
        mutation deleteComment($commentId: Int!) {
          deleteComment(input: { id: $commentId }) {
            comment {
              id
              postByPostid {
                commentcount
              }
            }
          }
        }
      `,
      variables: {
        commentId: second_commentId,
      },
    });
    expect(res.data.deleteComment).toEqual(null);
  });

  it("Verify Comment Count", async () => {
    let res = await aClient.query({
      query: gql`
        query getPost($postId: Int!) {
          post(id: $postId) {
            id
            commentcount
          }
        }
      `,
      variables: {
        postId: postId,
      },
    });
    expect(res.data.post.commentcount).toEqual(0);
  });

});

afterAll(() => {
  console.log(
    `Username: ${username} \n Password: ${password} \n PostId: ${postId} \n JwtToken: ${jwtToken}`
  );
});
