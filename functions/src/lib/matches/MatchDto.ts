export interface MatchDto {
  // DateTime
  readonly createdAt: number;

  readonly leftPlayerIds: ReadonlyArray<string>;
  readonly rightPlayerIds: ReadonlyArray<string>;

  // Integer
  readonly leftPoints: number;
  // Integer
  readonly rightPoint: number;
}
