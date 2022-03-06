import * as functions from "firebase-functions";
import * as admin from "firebase-admin";


// Start writing Firebase Functions
// https://firebase.google.com/docs/functions/typescript

admin.initializeApp({
    credential: admin.credential.cert({
        projectId: "digishala-aab53",
        privateKey:
            "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC9vNP7eaWf7rDa\ndkSbxw2q3jI+yQ0xMC2EqKEMDmQyyjmWQg4sMsfUT1+SbF+SzKzhBDZotBmxetVi\nqN3Vv6sGYFcRnSet6WXAMFmWMgrBrPT0N9z+zqiVS5KrvLLp8gsgwsSiAMW0SFeF\n7wAuhuwwxIt4XCrf726KCgjwaCUnkspd0ddyQCCmSPj/p26Zi+sl4edIv8LugzzG\ni7TPMCmxOAJEwrJiTzQLoUxCDYY8fwVFYXcmW7nfnFUnBLLs7MpzONY7/mjZigCe\nd0qYl1O41YSx1VRHfJAljg+r9yc4SEAuivgXPN72x3gSKmDCtczvtA/MoW3F5pV3\nal7j+/DVAgMBAAECggEAHAKjXM2hmNG5BBdPm5uwNdhlnIU70FYnch0e4VPCkQjv\npXIM+5Nnkr1BA7HCDj7vCqz/h0eHP389vznkveh0zBUu5WfI8tCw98VrhFPQ6LSq\n2N7iXi+ODbRBa98Inqbf4689LhllFm9TlG8rHLNIbQ6m9FbO8Y48SF6g4TTOv1+X\nf3NXF1iFZKCQVzFC22qnGK5mNtyau5D1khVjiH9g/PPEhfVG+nfQXo7xJ2rZ0Qto\n+vjqqAsjXDMAmxvHIBBLVJa/sBg0ET5H14v16fwxLENYMrz4Lg6KarfrweBS/jO7\nW/XqKm9krINMx2D7Lf9O9M4qd1Pfgiux+iKH60sbwQKBgQD/TbTXo0HE+fN2Y4VL\nQ1aOLTt/aJ0oMqKOPWxEfEhaCVAvJiYFgXtDrNEe7SNTZ5NKTasRvT/kCsUkvzkm\n06aBVZAx1TviwpnLzueDJnKtkEnjGjzRtZUx0e0NwTdOe6bYw3xPkqy37WFlYtao\nRjq/R8ytqpXhxWgSkMoqB4GpxQKBgQC+QVVD5fiYw+k14es0s/gRf6l6VnFBDn5n\n6bPjo6nhzHQF+5xcBfuvo7TnjBwzoNd2G9VCHTNY9T6SwQ+R0XpE2+CSOkHRfRdJ\nDqW6iOwgXWYShWMJYfc7XcEQea8TES1jgqA2Cvb/2h2QpImoX2osUefg/tFkaqwt\nYwbsLi9r0QKBgQCv/mdeB6L9ILlesXhfy8nNNQ1A5WMBJPa+S0VpaKuPtb/a4Ndx\nEDNjEa0PPrYNducoX6ZAElAK6gnBLTk+tMShf9RpJe+kgDX5M2aRGF4Rm9fzgFDQ\n1/ZDY82gn8N6jO8Vmp0FVb1PBYsQkzQayF8TIXHNfjzYaHc35SwYERinaQKBgQCf\nvFrKVxsRp+r1wmioJzHv/y9b95e+91xKAn12csL/QZloLIhq+tsF7HzGq2xCLJi6\nIUQ77iheWAnhTRa1ZxsxFSrHmwIH0O7r99BNfQhDZCd/BV7RUd8xiNW/72p+p71j\n/xhkR3B5/7cy6fJp2zJZY6s7zLYhiS5mLO5y/ZPzAQKBgEYXBtCIZN1it/UXd/92\noFsdYYrkI5jcsa6oJ26v+mcnpbJJY/6S9T7FznlkZWl/ZO+s40R7MUIfJ+L7BAWv\nsYtQfHRhYVGcdVvGwNGFEnbAERRtKVauYd6pY8+VlrydoBX1tkVOOiB8g3wC/IYd\nacC9D9LoJlRoQ6Epgbj3ttp2\n-----END PRIVATE KEY-----\n",
        clientEmail: "firebase-adminsdk-4lhsq@digishala-aab53.iam.gserviceaccount.com",
    }),
});
export const requestAcceptedbyAdmin = functions.firestore.document("/adminRequests/{reqId}").onUpdate(async (data, context) => {
    const afterUdpate = data.after.data()!;
    console.log("params");
    console.log(context.params);
    console.log(context.params);

    const user = await admin.auth().getUser(afterUdpate.userId);

    const token = (
        await admin.firestore().collection("users").doc(user.uid).get()
    ).data()!.token;
    await admin.messaging().send({
        token: token,
        data: {

            title: `Your ${afterUdpate.request} has been completed`,
            body: "Visit department to receive the document",
        },

        notification: {
            title: `Message from Department`,
            body: `Your ${afterUdpate.request} has been completed.`,
        },
        android: {
            priority: "high",
            notification: {
                defaultSound: true,
            },
        },
    });
});
export const creationOfAdminRequests = functions.firestore.document("/adminRequests/{reqId}").onCreate(async (data, context) => {
    const afterUdpate = data.data()!;
    console.log("params");
    console.log(context.params);
    console.log(context.params);

    const user = await admin.auth().getUser(afterUdpate.userId);
    const nameOfRequestor = (
        await admin.firestore().collection("users").doc(user.uid).get()
    ).data()!.name;

    const admins = await admin.firestore().collection("users").get();
    console.log("admins");
    admins.docs.map(async (a) => {
        const adminData = await admin.auth().getUser(a.data()!.uid);

        if (adminData?.customClaims?.admin == true) {
            const adminUser = a.data()!;
            console.log("admin user");
            console.log(adminUser.token);
            await admin.messaging().send({
                token: adminUser.token,
                data: {

                    title: `New ${afterUdpate.request} received`,
                    body: `${nameOfRequestor} has requested ${afterUdpate.request}`,
                },

                notification: {
                    title: `New ${afterUdpate.request} received`,
                    body: `${nameOfRequestor} has requested ${afterUdpate.request}`,
                },
                android: {
                    priority: "high",
                    notification: {
                        defaultSound: true,
                    },
                },
            });
        }
    });


});

export const creationOfBookRecords = functions.firestore.document("/libraryRecords/{reqId}").onCreate(async (data, context) => {
    const afterUdpate = data.data()!;
    console.log("params");
    console.log(context.params);
    console.log(context.params);

    const user = await admin.auth().getUser(afterUdpate.studentUid);
    const nameOfRequestor = (
        await admin.firestore().collection("users").doc(user.uid).get()
    ).data()!.name;

    const librarians = await admin.firestore().collection("users").where("level", "==", "LIBRARIAN").get();
    console.log("library");
    librarians.docs.map(async (a) => {
        const librarian = a.data();

        console.log("lobrarian user");
        console.log(librarian.token);
        await admin.messaging().send({
            token: librarian.token,
            data: {

                title: `New Book Request received`,
                body: `${nameOfRequestor} has requested ${afterUdpate.bookName}`,
            },

            notification: {
                title: `New Book Request received`,
                body: `${nameOfRequestor} has requested ${afterUdpate.bookName}`,
            },
            android: {
                priority: "high",
                notification: {
                    defaultSound: true,
                },
            },
        });
    });


});

export const bookRecordStatus = functions.firestore.document("/libraryRecords/{reqId}").onUpdate(async (data, context) => {
    const afterUdpate = data.after.data()!;
    console.log("params");
    console.log(context.params);
    console.log(context.params);

    const user = await admin.auth().getUser(afterUdpate.studentUid);

    const token = (
        await admin.firestore().collection("users").doc(user.uid).get()
    ).data()!.token;
    if (afterUdpate.isVerified == false) {
        await admin.messaging().send({
            token: token,
            data: {

                title: `Your request for ${afterUdpate.bookName} has been rejected`,
                body: "Visit library",
            },

            notification: {
                title: `Message from Library`,
                body: `Your request for ${afterUdpate.bookName} has been rejected`,
            },
            android: {
                priority: "high",
                notification: {
                    defaultSound: true,
                },
            },
        });
    } else if (afterUdpate.isVerified == true) {
        await admin.messaging().send({
            token: token,
            data: {

                title: `Your request for ${afterUdpate.bookName} has been approved`,
                body: "Visit department to receive the document",
            },

            notification: {
                title: `Message from Library`,
                body: `Your request for ${afterUdpate.bookName} has been approved`,
            },
            android: {
                priority: "high",
                notification: {
                    defaultSound: true,
                },
            },
        });
    }
});

export const attendanceAbsentNotification = functions.firestore.document("/users/{userId}/subjects/{subjectId}/dates/{dateId}").onCreate(async (data, context) => {
    const afterUdpate = data.data()!;

    console.log("userid");
    console.log(context.params.userId);
    console.log("subject id");
    console.log(context.params.subjectId);
    const user = await admin.auth().getUser(context.params.userId);
    const token = (
        await admin.firestore().collection("users").doc(user.uid).get()
    ).data()!.token;
    const isOnLeave = (
        await admin.firestore().collection("users").doc(user.uid).get()
    ).data()!.isOnaLeave;
    const subName = (
        await admin.firestore().collection("subjects").doc(context.params.subjectId).get()
    ).data()!.name;
    console.log(user.displayName);
    console.log(token);
    console.log(isOnLeave);
    console.log(subName);

    console.log("student user");
    if (isOnLeave == false && afterUdpate.isPresent == false) {
        await admin.messaging().send({
            token: token,
            data: {

                title: `Marked Absent`,
                body: `You were marked absent for ${subName}`,
            },

            notification: {
                title: `Marked Absent`,
                body: `You were marked absent for ${subName}`,
            },
            android: {
                priority: "high",
                notification: {
                    defaultSound: true,
                },
            },
        });

    }
});