context('tsd_get')

test_that("parse tags from string (ex: foo=bar baz=bap)", {
	tag_keys <- c("serial", "host", "site")
	tag_strings <- c(
		"host=foo serial=bar site=bap",
		"host=foo serial=bar site=baz"
		)
	actual <- parse_tags(tag_strings, tag_keys)
	expected <- data.frame(serial=c('bar', 'bar'), host=c('foo', 'foo'), site=c('bap', 'baz'))
	expect_equal(actual, expected)
})

content <- "
myservice.latency.avg 1288900000 42 reqtype=foo abc=bap
myservice.latency.avg 1288900000 51 reqtype=bar abc=bap
"

test_that("parse example content returned by TSD", {
	tags <- c('reqtype', 'abc')
	parsed <- parse_content(content, tags=tags)
	expect_true(is.data.frame(parsed))
	expect_equal(names(parsed)[1:3], c("metric", "timestamp", "value"))
	expect_equal(names(parsed)[4:ncol(dat)], tags)
	expect_true(is(parsed$timestamp, "POSIXct"))
	expect_equivalent(attr(parsed$timestamp, "tzone"), Sys.timezone())
	expect_equivalent(parsed$timestamp, Timestamp())
})
