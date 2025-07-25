#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQmlComponent>
#include <QQuickItem>
#include <QQuickWindow>
#include "chessActivity.h"
#include "SettingsManager.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    SettingsManager settingsManager;

    engine.rootContext()->setContextProperty("settingsManager", &settingsManager);

    ChessActivity Game;

    engine.rootContext()->setContextProperty("ChessActivity",&Game);

    engine.loadFromModule("Reversi1", "Main");

    if (!engine.rootObjects().isEmpty()) {
        QQuickWindow *window = qobject_cast<QQuickWindow *>(engine.rootObjects().first());
        if (window) {
            window->setMinimumWidth(960);
            window->setMinimumHeight(720);
            window->setMaximumWidth(960);
            window->setMaximumHeight(720);
        }
    }

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
