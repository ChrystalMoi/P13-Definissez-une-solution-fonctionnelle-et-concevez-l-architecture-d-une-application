import { Component, OnDestroy, OnInit } from '@angular/core';

import Talk from 'talkjs';

@Component({
  selector: 'app-talkjs-chat',
  standalone: true,
  imports: [],
  template: '',
  styles: '',
})
export class TalkjsChatComponent implements OnInit, OnDestroy {
  public isHelper: boolean = false;
  private session!: Talk.Session;

  ngOnInit(): void {
    this.initChatSession();
  }
  ngOnDestroy(): void {
    this.session?.destroy();
  }

  initChatSession(): void {
    Talk.ready.then((): void => {
      const user = new Talk.User({
        id: 'user',
        name: 'User',
        email: 'user@example.com',
        photoUrl: 'https://cdn-icons-png.flaticon.com/512/6596/6596121.png',
        role: 'default',
        welcomeMessage: null,
      });

      const helper = new Talk.User({
        id: 'helper',
        name: 'Chrystal',
        email: 'helper@example.com',
        photoUrl: 'https://talkjs.com/new-web/avatar-1.jpg',
        welcomeMessage:
          'Bonjour !\nJe suis Chrystal du support client, comment puis-je vous aider ?',
        role: 'default',
      });

      this.session = new Talk.Session({
        appId: 'tMiEuz6x',
        me: this.isHelper ? helper : user,
      });

      const conversation = this.session.getOrCreateConversation(
        'nouvelle_conversation'
      );
      conversation.setParticipant(user);
      conversation.setParticipant(helper);

      const popup = this.session.createPopup();
      popup.select(conversation);
      popup.mount({ show: true });
    });
  }

  refreshChatSession(): void {
    this.session?.destroy();
    this.initChatSession();
  }
}
