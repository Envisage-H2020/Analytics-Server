class BondingUser:
    def __init__(self, userId):
        self.userId = userId

    def toDict(self):
        bondingUser = dict()
        bondingUser['userId'] = self.userId
        bondingUser['periodicTableCount'] = self.periodicTableCount
        bondingUser['writeFormula'] = self.writeFormula
        bondingUser['completionCountWriteFormula'] = \
            self.completionCountWriteFormula
        bondingUser['chooseBond'] = self.chooseBond
        bondingUser['completionCountChooseBond'] = \
            self.completionCountChooseBond
        bondingUser['attemptCountsWriteFormulas'] = \
            self.attemptCountsWriteFormulas
        bondingUser['attemptCountsWriteFormula'] = \
            self.attemptCountsWriteFormula
