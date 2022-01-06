const request = require("request-promise");

const CLIENT_ID = "";
const CLIENT_SECRET = "";

request({
  method: "POST",
  uri: `https://login.mypurecloud.com/oauth/token`,
  headers: {
    "Content-Type": "application/x-www-form-urlencoded",
    Authorization: `Basic ${Buffer.from(
      `${CLIENT_ID}:${CLIENT_SECRET}`
    ).toString("base64")}`,
  },
  form: {
    grant_type: "client_credentials",
  },
  json: true,
})
  .then((response) => {
    let token = response.access_token;
    return request({
      method: "post",
      uri: `https://api.mypurecloud.com/platform/api/v2/processautomation/triggers`,
      headers: {
        Authorization: `Bearer ${token}`,
      },
      body: {
        target: {
          type: "Workflow",
          id: "", //the workflow ID goes here
        },
        enabled: true,
        matchCriteria: [],
        name: "Call Disconnected Trigger",
        topicName: "v2.detail.events.conversation.{id}.customer.end",
      },
      json: true,
    });
  })
  .then((response) => {
    console.log(response);
  })
  .catch((err) => {
    console.log(err);
    process.exit(-1);
  });
