# Leanpub Sales Analytics

This is a quickly hacked-together Rails application to let me visualize sales information for my book, [Everyday Rails Testing with RSpec](https://leanpub.com/everydayrailsrspec). I just run it locally--not hosted anywhere. If you've got Leanpub sales data and the means with which to run Rails applications on your computer, then maybe it will be useful to you, too.

Here's what it graphs:

- Total royalties per month
- Total sales per month
- Average price paid per book per month

Some issues to be aware of:

- **This is not a Leanpub product!** I'm only using the name Leanpub since this application is useless without a Leanpub sales data file. Leanpub is a service of Ruboss Technology Corporation, a corporation incorporated in British Columbia, Canada. I self-publish a book using this service, but am otherwise not affiliated with them in any way.
- **Rails is probably overkill for this application**, but it's what I know best and I wanted something quick.
- I've only written one book through Leanpub, so **there's no differentiation for sales of different books**. Adding this would be trivial, so I plan to do so if and when I get around to a second book.
- There are no tests, and the code itself isn't necessarily done in the Ruby Way. Pay no attention to the long `#index` method and duplicated code in `purchases_controller.rb`.