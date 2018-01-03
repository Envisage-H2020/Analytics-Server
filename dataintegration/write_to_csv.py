from pymongo import MongoClient
import subprocess


def WriteToCsv():
    windBashCommand = "mongoexport --db envisage --collection windUser --type csv --fields _id,addTurbine,changedPower,changedSimSpeed,changedWind,correctPower,powerStats.correct,powerStats.medianTimeOnTask,powerStats.over,powerStats.under,repairedTurbine,turbineOnOff,userId --out windUser.csv"
    windProcess = subprocess.Popen(windBashCommand.split(), stdout=subprocess.PIPE)
    windOutput, windError = windProcess.communicate()
    bondingBashCommand = "mongoexport --db envisage --collection bondingUser --type csv --fields _id,attemptCountsWriteFormula,attemptCountsWriteFormulas.attemptsWriteFormulaCF4,attemptCountsWriteFormulas.attemptsWriteFormulaCH4,attemptCountsWriteFormulas.attemptsWriteFormulaCaCl2,attemptCountsWriteFormulas.attemptsWriteFormulaH2O,attemptCountsWriteFormulas.attemptsWriteFormulaHCl,attemptCountsWriteFormulas.attemptsWriteFormulaKBr,attemptCountsWriteFormulas.attemptsWriteFormulaNaCl,attemptCountsWriteFormulas.attemptsWriteFormulaNaF,chooseBond.chooseBondCF4,chooseBond.chooseBondCH4,chooseBond.chooseBondCaCl2,chooseBond.chooseBondH2O.0,chooseBond.chooseBondH2O.1,chooseBond.chooseBondHCl,chooseBond.chooseBondKBr,chooseBond.chooseBondNaCl.0,chooseBond.chooseBondNaF,completionCountChooseBond,completionCountWriteFormula,periodicTableCount,userId,writeFormula.writeFormulaCF4,writeFormula.writeFormulaCH4,writeFormula.writeFormulaCaCl2,writeFormula.writeFormulaH2O.0,writeFormula.writeFormulaHCl,writeFormula.writeFormulaKBr,writeFormula.writeFormulaNaCl.0,writeFormula.writeFormulaNaF  --out bondingUser.csv"
    bondingProcess = subprocess.Popen(bondingBashCommand.split(), stdout=subprocess.PIPE)
    bondingOutput, bondingError = bondingProcess.communicate()
