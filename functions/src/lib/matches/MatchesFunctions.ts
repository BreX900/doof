import * as functions from "firebase-functions";
import { firestore } from "../instances";
import { MatchDto } from "./MatchDto";
import { StatDto } from "../stats/StatDto";

// Le statistiche per giocatore
// Le statistiche per squadra

functions.firestore
  .document("matches/{docId}")
  .onCreate(async (snapshot, context) => {
    const match = snapshot.data() as MatchDto;

    const statSnapshot = await firestore
      .collection("stats")
      .where("players", "array-contains", match.leftPlayerIds)
      .get();

    let stat: StatDto;
    if (statSnapshot.docs.length == 0) {
      stat = {
        // Generate document id
        id: firestore.collection("stats").doc().id,
        players: match.leftPlayerIds,
        matchesLost: 0,
        matchesWins: 0,
        goalsConceded: 0,
        goalsScored: 0,
      };
    } else {
      const doc = statSnapshot.docs[0];
      stat = {
        ...(doc.data() as StatDto),
        id: doc.id,
      };
    }

    const isLeftWinner = match.leftPoints > match.rightPoint;

    const updatedStat = {
      ...stat,
      matchesWins: isLeftWinner ? stat.matchesWins + 1 : stat.matchesWins,
      matchesLost: isLeftWinner ? stat.matchesLost : stat.matchesLost + 1,
      goalsScored: stat.goalsScored + match.leftPoints,
      goalsConceded: stat.goalsConceded + match.rightPoint,
    };

    await firestore.doc(stat.id).set(updatedStat);
  });
