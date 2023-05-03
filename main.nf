tsvPath = params.input

inputChan = Channel.empty()
tsvFile = file(tsvPath)
inputChan = extractFastq(tsvFile)

process NORMALIZE_VEPvcf {

	publishDir "${launchDir}/results/", mode: 'copy'

	memory 32.GB

	input:
	tuple val(file), val(sample)

	output:
	path "*"

	script:

	"""
	bcftools norm -m-both ${file} > HaplotypeCaller_${sample}_VEP.ann.NORM.vcf
	"""

}


workflow {

	NORMALIZE_VEPvcf(inputChan)

}


def returnFile(it) {
    if (!file(it).exists()) exit 1, "Missing file in TSV file: ${it}, see --help for more information"
    return file(it)
}

def extractFastq(tsvFile) {
    Channel.from(tsvFile)
        .splitCsv(sep: '\t')
        .map { row ->
            def file      = returnFile(row[0])
            def sample    = row[1]
            [file, sample]
        }
}
