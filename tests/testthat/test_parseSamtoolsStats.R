context("Parsing output of samtools stats")

test_that("Test that output includes expected sections", {
  expect_equal({
    data = readSamtoolsStats(file="/home/mmigdal/Documents/site_things/sumsamstats/sample1.stats.log")
    sum(names(data) == c("SN", "IS"))},
    2)
})

test_that("Test that function handles improper input correctly", {
  expect_error(
    readSamtoolsStats(file=1),
    "File argument must be of class character!\n")
  expect_error(
    readSamtoolsStats(file="/super/unexpected/file"),
    "File '/super/unexpected/file' doesn't exists!\n")
})
