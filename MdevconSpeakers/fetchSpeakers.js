var speakerTags = document.querySelectorAll('.post-row')

speakers = []

for (var i = 0; i < speakerTags.length; i++) {
  var speaker = speakerTags[i]
  var name = speaker.querySelector('.post-head h2').textContent
  var presentationTitle = speaker.querySelector('.title a').textContent
  speakers.push({"name" : name, "presentationTitle": presentationTitle})
}

webkit.messageHandlers.didFetchSpeakers.postMessage(speakers)