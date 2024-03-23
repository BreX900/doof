export interface StatDto {
  readonly id: string;

  readonly players: ReadonlyArray<string>;

  // integer
  readonly goalsConceded: number;
  // integer
  readonly goalsScored: number;

  // integer
  readonly matchesLost: number;
  // integer
  readonly matchesWins: number;
}
