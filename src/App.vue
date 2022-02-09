<template>
  <div id="app">
    <b-button v-b-modal.infoModal
              variant="default"
    >
      <b-icon-question-circle></b-icon-question-circle>
    </b-button>

    <b class="ml-3 mr-3">WeiRDLe</b>

    <b-button v-b-modal.configModal
              variant="default"
    >
      <b-icon-gear></b-icon-gear>
    </b-button>

    <b-modal id="configModal">
      <template #modal-header>
        <h5 class="modal-title">Настройки</h5>
        <b-button variant="light"
                  @click="$bvModal.hide('configModal')"
        >
          <span aria-hidden="true">&times;</span>
        </b-button>
      </template>
      <b-form>
        <b-form-group label="Длина слова">
          <b-form-radio-group
              id="size-setting"
              name="size-setting"
              v-model.number="sizePref"
              plain
          >
            <b-form-radio value="4">
              4
            </b-form-radio>
            <b-form-radio value="5">
              5
            </b-form-radio>
          </b-form-radio-group>
        </b-form-group>
        <b-form-group label="Сложность">
          <b-form-radio-group
              id="mode-setting"
              v-model.number="modePref"
              plain
          >
            <b-form-radio value="1">
              Легкотня
            </b-form-radio>
            <b-form-radio value="2">
              Обычно
            </b-form-radio>
            <b-form-radio value="3">
              Больно!
            </b-form-radio>
          </b-form-radio-group>
        </b-form-group>
      </b-form>
      <template #modal-footer>
        <b-button
            variant="light"
            @click="$bvModal.hide('configModal')"
        >Закрыть
        </b-button>
        <b-button variant="success"
                  @click="warnGameInProgress"
        >Поехали!
        </b-button>
      </template>
    </b-modal>

    <b-modal id="gameInProgressModal">
      <template #modal-header>
        <h5 class="modal-title">Игра в процессе!</h5>
        <b-button variant="light"
                  @click="$bvModal.hide('gameInProgressModal')"
        >
          <span aria-hidden="true">&times;</span>
        </b-button>
      </template>
      <p>Внимание, если обновить настройки текущая игра будет сброшена!</p>
      <template #modal-footer>
        <b-button
            variant="light"
            @click="$bvModal.hide('gameInProgressModal')"
        >Отмена
        </b-button>
        <b-button variant="success"
                  @click="updateConfig"
        >Да, сбросить
        </b-button>
      </template>
    </b-modal>

    <b-modal id="userModal"
             :visible="!userKey"
             no-close-on-backdrop
             no-close-on-esc
    >
      <template #modal-header>
        <h5 class="modal-title">Давайте знакомиться</h5>
      </template>
      <p>Мне нужно запоминать что вы уже отгадали, чтобы не повторяться.</p>
      <p>Но мне не нужно знать вашу почту, день рождения девичьей фамилии вашей матери и вот это всё.</p>
      <p>Я сам дам вам уникальный код, чтобы в случае чего восстановить прогресс игры. Например, на другом
        устройстве.</p>
      <b-row>
        <b-col>
          <b-button variant="success"
                    @click="setNewUser"
                    :disabled="!!newUserKey || !!existingUserKey"
          >Жми, если впервые
          </b-button>
        </b-col>
        <b-col>
          <b-form-input v-model.trim="existingUserKey"
                        :state="userFound"
                        :disabled="!!newUserKey"
                        placeholder="Вставьте код, если есть"
          ></b-form-input>
        </b-col>
      </b-row>
      <b-alert class="mt-3"
               variant="info"
               :show="!!newUserKey"
      >
        <p class="text-center">Скопируйте куда-нибудь код ниже:</p>
        <p class="text-center">{{ newUserKey }}</p>
      </b-alert>
      <template #modal-footer>
        <b-button variant="success"
                  @click="setUser"
                  :disabled="!existingUserKey && !newUserKey"
        >Поехали
        </b-button>
      </template>
    </b-modal>

    <b-modal id="infoModal">
      <template #modal-header>
        <h5 class="modal-title">Об игре</h5>
        <b-button variant="light"
                  @click="$bvModal.hide('infoModal')"
        >
          <span aria-hidden="true">&times;</span>
        </b-button>
      </template>
      <p>
        Правила здесь точно такие же, как и в <a href="https://www.powerlanguage.co.uk/wordle/"
                                                 target="_blank"
                                                 rel="noopener nofollow"
      >оригинальногй игре</a>
        или в её <a href="https://wordle.belousov.one/"
                    target="_blank"
                    rel="noopener nofollow"
      >русской версии</a>.
      </p>
      <p>Разница в том, что здесь можно менять длину слова и выбирать сложность.</p>
      <p>И поверьте, уроверь "Больно!" я так назвал не зря.</p>
      <p>А, еще тут нет ограничения на одно слово в день. Хоть весь день убивайтесь!</p>
      <p>Код проекта: <a href="https://github.com/iVovolk/wrdl-front"
                         target="_blank"
                         rel="noopener nofollow"
      >фронт</a>, <a href="https://github.com/iVovolk/wrdl-back"
                     target="_blank"
                     rel="noopener nofollow"
      >бэк</a></p>
      <template #modal-footer>
        <b-button
            variant="light"
            @click="$bvModal.hide('infoModal')"
        >Ок
        </b-button>
      </template>
    </b-modal>

    <b-modal id="statsModal">
      <template #modal-header>
        <h5 v-if="roundSuccess"
            class="modal-title"
        >Ура!</h5>
        <h5 v-else
            class="modal-title"
        >Горюшко.</h5>
        <b-button variant="light"
                  @click="$bvModal.hide('statsModal')"
        >
          <span aria-hidden="true">&times;</span>
        </b-button>
      </template>
      <h5 class="mb-3"
          v-if="!roundSuccess"
      >Было загадано слово: <b>{{ solution }}</b></h5>
      <h6>Статистика слова:</h6>
      <b-list-group class="mb-3">
        <b-list-group-item class="d-flex justify-content-between align-items-center">
          Слово загадано раз:
          <b-badge variant="primary"
                   pill
          >{{ roundStats.wordTotal }}
          </b-badge>
        </b-list-group-item>
        <b-list-group-item class="d-flex justify-content-between align-items-center">
          Слово отгадали:
          <b-badge variant="primary"
                   pill
          >{{ roundStats.wordSuccesses }}
          </b-badge>
        </b-list-group-item>
        <b-list-group-item class="d-flex justify-content-between align-items-center">
          Слово не отгадали:
          <b-badge variant="primary"
                   pill
          >{{ roundStats.wordFails }}
          </b-badge>
        </b-list-group-item>
      </b-list-group>
      <h6>Статистика пользователя:</h6>
      <b-list-group>
        <b-list-group-item class="d-flex justify-content-between align-items-center">
          Раундов сыграно:
          <b-badge variant="primary"
                   pill
          >{{ roundStats.userTotal }}
          </b-badge>
        </b-list-group-item>
        <b-list-group-item class="d-flex justify-content-between align-items-center">
          Слов отгадано:
          <b-badge variant="primary"
                   pill
          >{{ roundStats.userSuccesses }}
          </b-badge>
        </b-list-group-item>
        <b-list-group-item class="d-flex justify-content-between align-items-center">
          Слов не отгадано:
          <b-badge variant="primary"
                   pill
          >{{ roundStats.userFails }}
          </b-badge>
        </b-list-group-item>
      </b-list-group>

      <template #modal-footer>
        <b-button
            variant="light"
            @click="startNewRound(); $bvModal.hide('statsModal')"
        >Еще разок
        </b-button>
      </template>
    </b-modal>
    <hr>
    <div class="word-plate">
      <div v-for="(word, i) in matrix"
           :key="i"
           class="word"
      >
        <div v-for="(lo, j) in word"
             :key="j"
             class="letter"
             :class="lo.bg"
        >
          {{ lo.ltr }}
        </div>

      </div>
    </div>
    <div class="footer">
      <div class="keyboard">
        <div class="letters">
          <div v-for="(e,i) in letters"
               :key="i"
               class="letter-row"
          >
            <b-button v-if="i===2"
                      class="btn-del"
                      variant="light"
                      @click="delLetter"
            >
              <b-icon-backspace></b-icon-backspace>
            </b-button>
            <div v-for="(l, j) in e"
                 :key="j"
                 class="letter-btn"
            >
              <b-button :class="kbKeyClass(l)"
                        @click="handleLetterSelection(l)"
              >{{ l }}
              </b-button>
            </div>
            <b-button v-if="i===2"
                      class="btn-enter"
                      variant="light"
                      @click="checkWord"
            >
              <b-icon-arrow-return-left></b-icon-arrow-return-left>
            </b-button>
          </div>
        </div>

      </div>
    </div>
  </div>
</template>

<script>

import axios from 'axios'

export default {
  name: 'App',
  data () {
    return {
      size: null,
      mode: null,
      sizePref: null,
      modePref: null,
      matrix: [],
      currentRow: 0,
      currentIndex: 0,
      currentWord: '',
      letters: [
        ['й', 'ц', 'у', 'к', 'е', 'н', 'г', 'ш', 'щ', 'з', 'х', 'ъ'],
        ['ф', 'ы', 'в', 'а', 'п', 'р', 'о', 'л', 'д', 'ж', 'э'],
        ['я', 'ч', 'с', 'м', 'и', 'т', 'ь', 'б', 'ю']
      ],
      lInPlace: [],
      lOuttaPlace: [],
      lMiss: [],
      gameInProgress: false,
      userKey: 'xxx',
      newUserKey: null,
      existingUserKey: null,
      userFound: null,
      roundStopped: false,
      solution: null,
      roundSuccess: false,
      roundStats: {
        userFails: 0,
        userSuccesses: 0,
        userTotal: 0,
        wordFails: 0,
        wordSuccesses: 0,
        wordTotal: 0
      }
    }
  },
  created () {
    const config = loadConfig()
    this.size = config.size
    this.mode = config.mode
    if (config.userKey) {
      this.checkUser(config.userKey)
    } else {
      this.userKey = null
    }
    this.initMatrix()
    this.sizePref = this.size
    this.modePref = this.mode
  },
  computed: {
    rows () {
      return this.mode === 3 ? this.size : this.size + 1
    }
  },
  methods: {
    initMatrix () {
      this.matrix = []
      const lo = { ltr: '', bg: 'bg-none' }
      for (let i = 0; i < this.rows; i++) {
        for (let j = 0; j < this.size; j++) {
          if ('object' !== typeof this.matrix[i]) {
            this.matrix[i] = []
          }
          this.matrix[i][j] = lo
        }
      }
    },
    handleLetterSelection (letter) {
      if (this.roundStopped) {
        return
      }
      if (this.currentIndex + 1 > this.size) {
        return
      }
      const word = this.matrix[this.currentRow]
      word[this.currentIndex] = { ltr: letter, bg: 'bg-none' }
      this.$set(this.matrix, this.currentRow, word)
      ++this.currentIndex
      this.updateCurrentWord()
    },
    delLetter () {
      if (this.roundStopped) {
        return
      }
      if (this.currentIndex === 0) {
        return
      }
      const word = this.matrix[this.currentRow]
      word[this.currentIndex - 1] = { ltr: '', bg: 'bg-none' }
      this.$set(this.matrix, this.currentRow, word)
      --this.currentIndex
      this.updateCurrentWord()
    },
    updateCurrentWord () {
      this.currentWord = ''
      this.matrix[this.currentRow].forEach((e) => {
        if (e.ltr.length) {
          this.currentWord += e.ltr
        }
      })
    },
    unsetCurrentWord () {
      const word = []
      const empty = { ltr: '', bg: 'bg-none' }
      for (let i = 0; i < this.size; i++) {
        word[i] = empty
      }
      setTimeout(() => {
        this.$set(this.matrix, this.currentRow, word)
        this.currentWord = ''
        this.currentIndex = 0
      }, 1000)
    },
    checkWord () {
      if (this.roundStopped) {
        return
      }
      if (this.currentWord.length < this.size) {
        return
      }
      this.gameInProgress = true
      let route = ''
      const lastTurn = this.rows === this.currentRow + 1
      if (lastTurn) {
        route = '/words/check/last-turn'
      } else {
        route = '/words/check'
      }
      axios.post(route, {
        userKey: this.userKey,
        mode: this.mode,
        size: this.size,
        word: this.currentWord
      })
          .then(res => {
            this.handleGuess(res.data.highlights)
            if (res.data.success) {
              this.roundSuccess = true
              this.roundStopped = true
              this.showStats()
              return
            }
            if (lastTurn) {
              if (res.data.success) {
                this.roundSuccess = true
              } else {
                this.roundSuccess = false
                this.solution = res.data.solution
              }
              this.roundStopped = true
              this.showStats()
              return
            }
            ++this.currentRow
            this.currentIndex = 0
          })
          .catch(err => {
            if (err.response.status === 404) {
              this.unsetCurrentWord()
              this.$bvToast.toast(err.response.data, {
                title: 'Нипанятна',
                variant: 'warning'
              })
              return
            }
            this.$bvToast.toast(err.response.data, {
              title: 'Ошибка при проверке слова',
              variant: 'danger'
            })
          })
    },
    handleGuess (res) {
      const word = this.matrix[this.currentRow]
      for (const i in res) {
        const index = parseInt(i)
        const e = res[i]
        const letter = word[index].ltr
        let bgClass = 'bg-none'
        switch (e) {
          case 1:
            if (this.lInPlace.indexOf(letter) === -1) {
              this.lInPlace.push(letter)
            }
            bgClass = 'bg-success'
            break
          case 0:
            if (this.lMiss.indexOf(letter) === -1) {
              this.lMiss.push(letter)
            }
            bgClass = 'bg-secondary'
            break
          case 2:
            if (this.lOuttaPlace.indexOf(letter) === -1) {
              this.lOuttaPlace.push(letter)
            }
            bgClass = 'bg-warning'
            break
        }
        word[index].bg = bgClass
      }
      this.$set(this.matrix, this.currentRow, word)
    },
    kbKeyClass (l) {
      let bgClass = 'btn-light'
      if (this.lMiss.indexOf(l) !== -1) {
        bgClass = 'btn-secondary'
      }
      if (this.lOuttaPlace.indexOf(l) !== -1) {
        bgClass = 'btn-warning'
      }
      if (this.lInPlace.indexOf(l) !== -1) {
        bgClass = 'btn-success'
      }
      return bgClass
    },
    warnGameInProgress () {
      if (this.gameInProgress) {
        this.$bvModal.show('gameInProgressModal')
        return
      }
      this.updateConfig()
    },
    updateConfig () {
      if (this.size === this.sizePref && this.mode === this.modePref) {
        return
      }
      this.$bvModal.hide('gameInProgressModal')
      this.$bvModal.hide('configModal')
      this.updateSize(this.sizePref)
      this.updateMode(this.modePref)
      this.startNewRound()
    },
    setNewUser () {
      axios.get('/user/new')
          .then(res => {
            this.newUserKey = res.data
          })
          .catch(err => {
            this.$bvToast.toast(err.response.data, {
              title: 'Ошибка при создании пользователя',
              variant: 'danger'
            })
          })
    },
    setUser () {
      if (this.newUserKey) {
        this.userKey = this.newUserKey
        setUserKey(this.userKey)
        this.$bvModal.hide('userInfo')
        return
      }
      if (this.existingUserKey) {
        axios.get(`/user/${this.existingUserKey}/check`)
            .then(res => {
              this.userKey = this.existingUserKey
              setUserKey(this.userKey)
              this.updateMode(res.data.mode)
              this.updateSize(res.data.size)
              this.$bvModal.hide('userInfo')
            })
            .catch(err => {
              if (err.response.status === 404) {
                this.userFound = false
                return
              }
              this.$bvToast.toast(err.response.data, {
                title: 'Ошибка при проверке пользователя',
                variant: 'danger'
              })
            })
      }
    },
    checkUser (key) {
      axios.get(`/user/${key}/check`)
          .then(res => {
            this.userKey = key
            this.updateMode(res.data.mode)
            this.updateSize(res.data.size)
          })
          .catch(err => {
            if (err.response.status === 404) {
              this.userKey = null
              return
            }
            this.$bvToast.toast(err.response.data, {
              title: 'Ошибка при проверке пользователя',
              variant: 'danger'
            })
          })
    },
    showStats () {
      axios.post('/stats', {
        userKey: this.userKey,
        mode: this.mode,
        size: this.size
      })
          .then(res => {
            this.roundStats = res.data
          })
          .catch(err => {
            this.$bvToast.toast(err.response.data, {
              title: 'Ошибка при загрузке статистики',
              variant: 'danger'
            })
          })
          .finally(() => {
            this.$bvModal.show('statsModal')
          })
    },
    startNewRound () {
      this.currentRow = 0
      this.currentIndex = 0
      this.currentWord = ''
      this.lMiss = []
      this.lInPlace = []
      this.lOuttaPlace = []
      this.initMatrix()
      this.roundStopped = false
      this.gameInProgress = false
      this.roundSuccess = false
      this.solution = null
      this.roundStats = {
        userFails: 0,
        userSuccesses: 0,
        userTotal: 0,
        wordFails: 0,
        wordSuccesses: 0,
        wordTotal: 0
      }
    },
    updateSize (size) {
      this.size = size
      this.sizePref = size
      updateSize(size)
    },
    updateMode (mode) {
      this.mode = mode
      this.modePref = mode
      updateMode(mode)
    }
  }
}

const loadConfig = () => {
  return {
    size: parseInt(localStorage.getItem('size')) || 4,
    mode: parseInt(localStorage.getItem('mode')) || 2,
    userKey: localStorage.getItem('userKey') || null
  }
}

const updateSize = (size) => {
  localStorage.setItem('size', size)
}

const updateMode = (mode) => {
  localStorage.setItem('mode', mode)
}

const setUserKey = (key) => {
  localStorage.setItem('userKey', key)
}

</script>


<style>
  html {
    position: relative;
    min-height: 100%;
  }

  #app {
    font-family: Avenir, Helvetica, Arial, sans-serif;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
    text-align: center;
    color: #2c3e50;
    margin-top: 30px;
    margin-bottom: 190px;
  }

  .word {
    display: flex;
    flex-direction: row;
    flex-wrap: nowrap;
    justify-content: center;
  }

  .letter {
    flex: 0 0 55px;
    margin: 3px;
    border: solid 2px #e5e5e5;
    height: 55px;
    line-height: 55px;
    font-size: 45px;
    border-radius: 3px;
    text-transform: capitalize;
    vertical-align: center;
  }

  .letter.bg-warning, .letter.bg-success, .letter.bg-secondary {
    color: #fff;
  }

  .letter-row {
    display: flex;
    flex-direction: row;
    flex-wrap: nowrap;
    justify-content: center;
  }

  .letter-btn {
    flex: 0 0;
    margin: 3px;
  }

  .letter-btn > button.btn {
    text-transform: uppercase;
    padding: 0.375rem 0.75rem;
    font-size: 1rem;
    line-height: 1.5;
  }

  .footer {
    position: absolute;
    bottom: 0;
    width: 100%;
    display: flex;
    height: 180px;
    justify-content: center;
    flex-direction: row;
    padding-bottom: 50px;
  }

  .btn-del, .btn-enter {
    padding: 0.17rem 0.5rem !important;
    margin: 3px;
  }

  .keyboard {
    display: flex;
    justify-content: center;
    flex-direction: row;
  }

  @media screen and (max-width: 320px) {
    .letter {
      flex: 0 0 35px;
      margin: 2px;
      height: 35px;
      line-height: 1.3;
      font-size: 25px;
    }

    .letter-btn {
      margin: 2px;
    }

    .letter-btn > button.btn {
      padding: 0.4rem 0.32rem;
      font-size: 0.8rem;
      line-height: 1.1;
    }

    .btn-del, .btn-enter {
      padding: 0.1rem 0.5rem !important;
      margin: 2px;
    }

    #app {
      margin-bottom: 158px;
    }

    .footer {
      height: 148px;
    }
  }

  @media screen and (min-width: 321px) and (max-width: 360px) {
    .letter {
      flex: 0 0 45px;
      margin: 2px;
      height: 45px;
      line-height: 45px;
      font-size: 30px;
      vertical-align: center;
    }

    .letter-btn > button.btn {
      padding: 0.55rem 0.3rem;
      font-size: 0.9rem;
      line-height: 1.1;
    }

    .btn-del, .btn-enter {
      padding: 0.05rem 0.5rem !important;
      margin: 3px;
    }

    #app {
      margin-bottom: 185px;
    }

    .footer {
      height: 174px;
    }
  }

  @media screen and (min-width: 361px) and (max-width: 525px) {
    .letter {
      flex: 0 0 45px;
      margin: 3px;
      height: 45px;
      line-height: 45px;
      font-size: 30px;
      vertical-align: center;
    }

    .letter-btn > button.btn {
      padding: 0.55rem 0.35rem;
      font-size: 1.1rem;
      line-height: 1.1;
    }

    .btn-del, .btn-enter {
      padding: 0.05rem 0.5rem !important;
      margin: 3px;
    }

    #app {
      margin-bottom: 195px;
    }

    .footer {
      height: 184px;
    }
  }
</style>
