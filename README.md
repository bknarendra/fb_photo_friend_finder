To use the script:

```
git checkout repo
cd fb_photo_friend_finder
bundle install
```

You need to get the FB access token to allow uploading temporary photos to FB. Use the [Graph API Explorer](https://developers.facebook.com/tools/explorer#_=_) to get a token that has the permissions `publish_actions` and `user_photos`.  Copy and paste the access token in the script.

Next you need the FB cookies.
- Open facebook.com in Chrome and login.
- Then open Developer Tools and switch to Network Tab.
- Reload the page.
- Right click on any request which goes to facebook.com and select Copy as cURL option. It will copy that request as a cURL command.
- Paste it in some editor. It will look something like this.
curl 'https://www.facebook.com/photo.php?fbid=&set=' -H 'accept-encoding: gzip, deflate, sdch, br' -H 'accept-language: en-US,en;q=0.8' -H 'authority: www.facebook.com' -H 'cookie: cookies' --compressed
- Copy the cookie block (everything in '' which has cookie written)
- Paste that in the script and save.

To run the script.

```
ruby photo_friend_finder.rb "path to the photo"
```
