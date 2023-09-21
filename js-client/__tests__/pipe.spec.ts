import { Pipe } from "../src";

describe("pipe", () => {
    it.only(
        "should work",
        async () => {
            const c = new Pipe({ url: "https://api.exampleapp.test.lncd.pl/leanpipe" });

            const t1 = c.topic("ExampleApp.Core.Contracts.Projects.EmployeeAssignmentsTopic", {
                EmployeeId: "employee_01HAPJG153XZ83RR9PPRV7M894",
            });

            const t2 = c.topic("ExampleApp.Core.Contracts.Projects.EmployeeAssignmentsTopic", {
                EmployeeId: "employee_01HAPJG153XZ83RR9PPRV7M894",
            });

            const s1 = t1.subscribe(message => {
                console.log(message);
            });
            await delay(500);

            const s2 = t2.subscribe();

            await delay(3000);

            s2.unsubscribe();
            s1.unsubscribe();

            await delay(3000);
        },
        1000 * 60,
    );

    it(
        "should work",
        async () => {
            const c = new Pipe({ url: "https://leanpipe-example.test.lncd.pl/pipe" });

            const t1 = c.topic("LeanPipe.Example.Contracts.Auction", {
                AuctionId: "hello",
                Authorized: false,
            });

            const t2 = c.topic("LeanPipe.Example.Contracts.Auction", {
                AuctionId: "hello",
                Authorized: false,
            });

            const s1 = t1.subscribe();
            await delay(500);

            const s2 = t2.subscribe();

            await delay(5000);

            s2.unsubscribe();
            s1.unsubscribe();
        },
        1000 * 60,
    );
});

function delay(timeout = 500) {
    return new Promise(resolve => setTimeout(resolve, timeout));
}
